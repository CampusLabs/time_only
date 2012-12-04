# TimeOfDay

A simple class for handling time and only time. No dates, no time zones, just good old time of day.
At the moment, `TimeOfDay` only supports resolution to 1 second.

## Installation

Add this line to your application's Gemfile:

    gem 'time_of_day'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install time_of_day

## Usage

`TimeOfDay` attempts to implement the same functionality as `Time` where it makes sense to do so.

    require 'time_of_day'
    
    time = TimeOfDay.new(8, 0, 2)
    # => '08:00:02'
    
    time.hour
    # => 8
    
    time.min
    # => 0
    
    time.sec
    # => 2
    
    time.strftime('The time is %-l:%M:%S %P.')
    # => 'The time is 1:03:56 pm.'
    
    # adding times rolls the time forward and returns a new TimeOfDay
    TimeOfDay.new(23, 59, 59) + 3
    # => '00:00:02'
        
    morning_flights, afternoon_flights = departure_times.partition(&:am?)
    
    current_time = TimeOfDay.now
    
    # and many more...
    
Method documentation can be found in the source.
    
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
