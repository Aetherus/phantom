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

phantom.pid   #=> PID or nil if fork fails
```

The `on_ok` parameter can be any instances that respond to `call` with no arguments.

The `on_error` parameter can be any instances that respond to `call` with 1 argument to take the exception.

None of the parameters is required.

If `pid_file` is given, `Phantom.run` first check the existence of the file, if exits, raises a `Phantom::ForkError`.

## TODO

Implement monitoring and intercepting mechanism

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
