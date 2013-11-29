# Phantom

This gem is made to implement the callback mechanism to sub processes.

## Requirements

Ruby >= 2.0.0

This gem uses `::fork` and therefore is not compatible with JRuby.

## Installation

Add this line to your application's Gemfile:

    gem 'phantom'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install phantom

## Usage

```ruby
begin
  phantom = Phantom.run(pid_file: '/path/to/your.pid',
                        on_ok: method(:my_ok_callback),
                        on_error: method(:my_error_callback)) do
    # Do your background job here
  end
rescue Phantom::ForkError => e
  puts e.pid_file  #=> pid file path
  puts e.message   #=> error message
end

phantom.pid     #=> PID or nil if fork fails
phantom.name    #=> name of the subprocess. The name equals to the name displayed by linux command `ps`.
phantom.status  #=> 'Alive' | 'Dead' | 'Paused'
phantom.dead?   #=> true if the sub process is dead (i.e. either ended normally or killed)
phantom.alive?  #=> true if not dead.

phantom.stop      #=> pause the sub process
phantom.pause     #=> pause is an alias of stop
phantom.continue  #=> resume the sub process
phantom.resume    #=> resume is an alias of continue

phantom.kill(1)     #=> send signal to the sub process
phantom.kill(:TERM) #=> you can as well use the POSIX signal names

phantom.terminate   #=> terminate the sub process gracefully
phantom.abort!      #=> force the sub process to end immediately
```

The `on_ok` parameter can be any instances that respond to `call` taking no arguments.

The `on_error` parameter can be any instances that respond to `call` taking 1 argument, the exception.

None of the parameters is required.

If `pid_file` is given, `Phantom.run` first check the existence of the file, if exits, raises a `Phantom::ForkError`.

If you want a global mutex (i.e. mutex between multiple processes), you can use the `Phutex` instances.

```ruby
@phutex = Phantom::Phutex.new('path/to/your/lock/file')

@phutex.sync do
  # do your job here
end
```

## Caution
1. The status is NOT completely retrieved from the sub process, so any manipulation out of the phantom instance,
except terminating the sub process, will not be recognized.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
