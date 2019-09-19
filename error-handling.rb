# One of the few common cases where it’s sane to rescue from Exception is for logging/reporting purposes, in which case you should immediately re-raise the exception:

begin
  # iceberg?
rescue Exception => e
  # do some logging
  raise e  # not enough lifeboats ;)
end


begin
  # do stuff
rescue Exception => e
  myLogger.error("uncaught #{e} exception while handling connection: #{e.message}")
  myLogger.error("Stack trace: #{backtrace.map {|l| "  #{l}\n"}.join}")
end


# First of all, you really shouldn't subclass Exception. It is the superclass of all Ruby exceptions, including NoMemoryError, SyntaxError, Interrupt, SystemExit; all of which you don't normally need to rescue from. Doing so, whether accidentally or on purpose, is discouraged since it can prevent a program from exiting properly, even if it was interrupted by the user. It can also hide or produce some quite obscure bugs.

# What you want to subclass is StandardError, which is the superclass of most Ruby errors we see in day-to-day programming. This class is also the one which will be rescued should you not specify one:

begin
  object.do_something!
rescue => error    # will rescue StandardError and all subclasses
  $stderr.puts error.message
end

# I believe this is the "default behavior" you are looking for. You can handle a specific error, then all other errors in general:

class CustomApplicationError < StandardError
end

begin
  object.do_something!
rescue CustomApplicationError => error
  recover_from error
rescue => error
  log.error error.message
  raise
end

# The else clause is not meaningless in error handling. It will execute the nested code if and only if no exceptions were raised, as opposed to the ensure clause which will execute code regardless. It allows you to handle success cases.

begin
  object.do_something!
rescue => error
  log.error error.message
else
  log.info 'Everything went smoothly'
end