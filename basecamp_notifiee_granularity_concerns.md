The `User` class is the starting point of a kind of falling composition tree, with a
- `User` who acts as a `Notifiee`
- The `User` instantiates `@notifications`
- Notifications in turn instantiates further subclasses including `Granularity`

Each composed class creates another layer of composed classes underneath instantiated with `self`, which allows a chain of delegated methods that provide a user-friendly API for calling methods on the `User`, encapsulated by the `Notifiee` concern

```ruby
# This User model can act as a notifiee when included in a mention (in a comment etc)
# - a notifiee is someone who acts in that role, someone who can be mentioned
# Personable is included in a number of different Models, allowing for different
# types of "Persons", eg Users, Clients, Tombstones

class User < ActiveRecord::Base
  include Personable
  include Notifiee

  def attributes_for_person
    {}
  end

  def settings; end
end

class Client < ActiveRecord::Base
  include Personable

  def attributes_for_person
    {}
  end
end

class Tombstone < ActiveRecord::Base
  include Personable
end

module Notifiee
  # This exists to provide a nice user interface `Current.user.notifications`
  # ... rather than awkwardly having to directly access the class `User::Notifications.new(Current.user)`
  # Very simple concern who's role is to provide a pathway to the User::Notifications class

  extend ActiveSupport::Concern

  included do; end

  def notifications
    @notifications ||= User::Notifications.new(self)
  end
end

class User::Notifications
  # Vanilla Ruby class that doesn't inherit from anything
  # Uses composition, and instantiates another layer of composed classes
  # Aggregation of all of the considerations around notifications
  # Provides the Redis connection
  # Provides the interface to other specific classes, and passes itself into these subclasses

  include RedisConnectable
  set_redis :notifications, clearable: true

  attr_reader :user
  delegate :person, to: :user
  delegate :time_zone, to: :person
  delegate :snoozed?, :off_by_choice?, :off_by_schedule?, :on?, to: :state

  def initialize(user)
    @user = user
  end

  def scheduled; end
  def snoozed; end
  def platforms; end

  def granularity
    @granularity ||= User::Notifications::Granularity.new(self)
  end

  def presentation; end
  def bundled; end
  def accepts(deliverable); end
  def on!; end
  def off!; end
  def state;end

  private
    # Someone with access to User has access to @notifications, but don't want to give them access to the redis_key so the method is private
    # However this means that Granularity has to use :send to access this user_key which is a tradeoff
    # Ruby doesn't give us access to this method because we are using Composition rather than an Inheritance tree

    def user_key
      "notifications/user:#{user.id}"
    end

    def toggle_key
      "#{user_key}/toggle"
    end
end

class User::Notifications::Granularity
  # Another plain Ruby class that takes the Notifications object as it's only parameter
  # Allows us to delegate :redis, and all the way back up the tree to User
  # Uses Redis to store the choice
  # Provides a specialised class to encapsulate Notification settings as well as the checks & rules for deliverables

  attr_reader :notifications

  delegate :user, :redis, to: :notifications

  OPTIONS = %w(pings_and_mentions everything)
  DEFAULT = 'everything'

  def initialize(notifications)
    @notifications = notifications
  end

  delegate :pings_and_mentions?, :everything?, to: :choice

  def choice=(option)
    redis.set granularity_key, option.presence_in(OPTIONS) || DEFAULT
  end

  def allows?(deliverable)
    case
    when everything?
      true
    when pings_and_mentions?
      deliverable.is_a?(Mention) || ping?(deliverable)
    end
  end

  private
    def choice
      @choice ||=(redis.get(granularity_key) || DEFAULT).inquiry
    end

    def granularity_key
      "#{notifications.send(:user_key)}/granularity"
    end

    def ping?(deliverable); end
    def chat_line_event?(deliverable);end
end
```

This setup can then used in the `SettingsController`:

```ruby
class My::Notifications::SettingsController < ApplicationController
  after_action :track_update_for_customer, only: :update

  def show; end
  def edit; end

  def update
    update_platforms
    update_presentation
    update_granularity
    update_schedule
    update_bundle

    redirect_to edit_my_notifications_settings_url, notice: 'Settings saved!'
  end

  private
    def default_schedule;end
    def update_platforms;end
    def update_presentation;end

    def update_granularity
      Current.user.notifications.granularity.choice = params[:granularity]
    end

    def update_schedule;end
    def update_bundle;end
    def schedule_params;end
    def schedule_workdays;end
end
```
