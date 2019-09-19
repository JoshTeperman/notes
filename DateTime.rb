date = DateTime.new(2019, 07, 29)
# Mon, 29 Jul 2019 00:00:00 +0000
date2 = Date.new(2019, 07, 29)
# Mon, 29 Jul 2019

# Add time to a date => 
Date.new(2015, 2, 10).to_datetime + Time.parse("16:30").seconds_since_midnight.seconds
# Tue, 10 Feb 2015 16:30:00 +0000

Date.parse('2018-2-4')
# Sun, 04 Feb 2018
Time.parse('2018-2-4')
# 2018-02-04 00:00:00 +1100
DateTime.parse('2018-2-4')
# Sun, 04 Feb 2018 00:00:00 +0000


# strftime:
# %F is equal to %Y-%m-%d  
# %T is equal to %H:%M:%S


// # TIMEZONES in Postgres // 
# https://engineering.liefery.com/2017/10/25/times-in-rails-5.html
# -> doesn't offer a complete solution

Current time is October 19th, 11:00 am CEST. 
My sale starts tomorrow (October 20th)
My store opens every day at 9 am

... therefore:

store = Store.create(
  sale_start_at: Time.current + 1.day,
  opening_time: Time.zone.parse('09:00')
)

# application.rb
config.time_zone = "Berlin"

store.sale_start_at # -> Time.current
# ! => Fri, 20 Oct 2017 11:00:00 CEST +02:00 # This is correct
# Stored as CEST b/d config.time_zone is Berlin.
# If we changed to "London", would change to:
# => Fri, 20 Oct 2017 10:00:00 BST +01:00
store.sale_start_at.class # -> Time.zone.parse('09:00')
# => ActiveSupport::TimeWithZone
# In console, sale_started_at value returns ActiveSupport::TimeWithZone object
SELECT sale_start_at FROM corn_stores WHERE id = 1
# => 2017-10-20 09:00:00.513386
# Still stored in Postgres as UTC, but prints to console to the Berlin timezone CEST

store.opening_time
# ! => "2000-01-01T07:00:00.000Z" # WTF
# Now comes with Jan 1 200 Date attached to it (legacy Rails default)
store.opening_time.class
# => Time
# In console, opening_time value returns Time object
SELECT opening_time FROM corn_stores WHERE id = 1
# => 07:00:00
# stored in Postgres as UTC, same as sale_start_at
# we want to print to console in Berlin time (11:00am CEST)

// EXPLANATION:

# As far as Postgres is concerned, sale_start_at and opening_time have no timezone and are in UTC
# Rails applies time zone logic to them the UTC times
# The sale_started_at column is datetime, therefore is time zone aware
# The opening_time column value in Postgres is just a time (no date!), therefore not timezone aware

datetime: # timezone aware, will be converted to the config.time_zone when printed
time: # not timezone aware, will not be converted


// THE_FIX:

# application.rb
config.active_record.time_zone_aware_types = [:datetime, :time]

corn_store.sale_start_at
# => Fri, 20 Oct 2017 11:00:00 CEST +02:00
# => ActiveSupport::TimeWithZone

corn_store.opening_time
# => Sat, 01 Jan 2000 08:00:00 CET +01:00
# => ActiveSupport::TimeWithZone
# ! WTF -> has become timezone aware, but CET??

# Set as '9:00 CEST', converted to '7:00 UTC', and returned as '08:00 CET', which is winter time...

SET-UP in RAILS / POSTGRES:

# migration, use 'time with time zone'
# default for time is 'time without time zone'
# can also config.time_zone = ''

class CreatePeppers < ActiveRecord::Migration
  def change
    create_table :peppers do |t|
      t.column :runs, 'timestamp with time zone'
      t.column :stops, 'time with time zone'
    end
  end
end

# UTC format with timezone information" isn't specifying a time. It's specifying time AND place.
# PostgreSQL's "timestamp with time zone" doesn't in fact store a time zone. It stores a UTC timestamp but it accepts a time zone. 
# Possible to create a timestamp without time zone and a separate timezone. That way you can say "2pm on Tuesday, London Time".


# If you want to know how many minutes, hours or days between two dates you can do something like:
  started_at = 2.days.ago
  time_diff = (Time.current - started_at)
  (time_diff / 1.minute).round
  => 2880
  (time_diff / 1.hour).round
  => 48q
  (time_diff / 1.day).round
  => 2

TimeZones
"Darwin" => "Australia/Darwin", 
"Adelaide" => "Australia/Adelaide", 
"Canberra" => "Australia/Melbourne", 
"Melbourne" => "Australia/Melbourne", 
"Sydney" => "Australia/Sydney", 
"Brisbane" => "Australia/Brisbane", 
"Hobart" => "Australia/Hobart", 

