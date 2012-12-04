class TimeOnly
  include Comparable

  SECONDS_PER_MIN  = 60
  SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN
  SECONDS_PER_DAY  = 24 * SECONDS_PER_HOUR

  # Public: Initialize a TimeOnly.
  #
  # seconds - The Integer number of seconds since midnight.
  #
  # Examples
  #
  #   TimeOnly.at(4)
  #   # => '00:00:04'
  def self.at(seconds)
    new(seconds)
  end

  def self.now
    time = Time.now

    new(time.hour, time.min, time.sec)
  end

  # Public: Initialize a TimeOnly.
  #
  # seconds - The Integer number of seconds since midnight.
  #   OR
  # hours   - The Integer number of hours.
  # minutes - The Integer number of minutes.
  # seconds - The Integer number of seconds.
  #
  # Examples
  #
  #   TimeOnly.new(4)
  #   # => '00:00:04'
  #
  #   TimeOnly.new(13, 24, 56)
  #   # => '13:24:56'
  def initialize(*args)
    seconds = case args.size
      when 1
        args.first
      when 3
        hours, minutes, seconds = args

        raise ArgumentError, 'hours must be between 0 and 23'   if hours   < 0 || hours   > 23
        raise ArgumentError, 'minutes must be between 0 and 59' if minutes < 0 || minutes > 59
        raise ArgumentError, 'seconds must be between 0 and 59' if seconds < 0 || seconds > 59

        (hours * SECONDS_PER_HOUR) + (minutes * SECONDS_PER_MIN) + seconds
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1 or 3)"
      end

    @seconds_since_midnight = mod_by_day(seconds)
  end

  # Public: Add seconds to the time and return that as a new value. If the value
  # exceeds the number of seconds in a day the time will roll forwardd.
  #
  # seconds - The Integer number of seconds.
  #
  # Examples
  #
  #   TimeOnly.new(4) + 3
  #   # => '00:00:07'
  #
  #   TimeOnly.new(23, 59, 59) + 3
  #   # => '00:00:02'
  #
  # Returns a new TimeOnly.
  def +(seconds)
    self.class.new(mod_by_day(@seconds_since_midnight + seconds))
  end

  # Public: Subtract seconds from the time and return that as a new value. If the
  # value is less than zero seconds in a day the time will roll backwards.
  #
  # seconds - The Integer number of seconds.
  #
  # Examples
  #
  #   TimeOnly.new(4) - 3
  #   # => '00:00:01'
  #
  #   TimeOnly.new(0, 0, 0) - 3
  #   # => '23:59:57'
  #
  # Returns a new TimeOnly.
  def -(seconds)
    self + (seconds * -1)
  end

  def ==(other)
    to_i == other.to_i
  end
  alias_method :eql?, :==

  def <=>(other)
    to_i <=> other.to_i
  end

  def am?
    hour < 12
  end

  def hour
    @hour ||= @seconds_since_midnight / SECONDS_PER_HOUR
  end

  def min
    @min ||= (@seconds_since_midnight % SECONDS_PER_HOUR) / SECONDS_PER_MIN
  end

  def pm?
    !am?
  end

  def sec
    @sec ||= @seconds_since_midnight % SECONDS_PER_MIN
  end

  # Public: Formats time according to the directives in the given format string.
  # The directives begins with a percent (%) character. Any text not listed as a
  # directive will be passed through to the output string.)
  #
  # The directive consists of a percent (%) character, zero or more flags and a 
  # conversion specifier as follows.
  #
  #   %<flags><conversion>
  #
  #  Flags:
  #    - don't pad a numerical output
  #
  #  Directives:
  #    %H - Hour of the day, 24-hour clock, zero-padded (00..23)
  #    %k - Hour of the day, 24-hour clock, blank-padded ( 0..23)
  #    %I - Hour of the day, 12-hour clock, zero-padded (01..12)
  #    %l - Hour of the day, 12-hour clock, blank-padded ( 1..12)
  #    %P - Meridian indicator, lowercase (``am' or ``pm')
  #    %p - Meridian indicator, uppercase (``AM' or ``PM')
  #    %M - Minute of the hour (00..59)
  #    %S - Second of the minute (00..60)
  #
  #  Literal strings:
  #    %n - Newline character (\n)
  #    %t - Tab character (\t)
  #    %% - Literal ``%'' character)
  #
  #  Combinations:
  #    %X - Same as %T
  #    %r - 12-hour time (%I:%M:%S %p)
  #    %R - 24-hour time (%H:%M)
  #    %T - 24-hour time (%H:%M:%S)
  #
  # format - The String containing directives.
  #
  # Examples
  #
  #   TimeOnly.new(12, 34, 56).strftime('%r')
  #   # => '12:34:56 PM'
  #
  #   TimeOnly.new(1, 3, 56).strftime('The time is %-l:%M:%S %P.')
  #   # => 'The time is 1:03:56 pm.'
  #
  # Returns the formatted String.
  def strftime(format)
    format = format.dup

    format.gsub!(/%[rRTX]/) do |token|
      case token
      when '%r'
        '%I:%M:%S %p'
      when '%R'
        '%H:%M'
      when '%T', '%X'
        '%H:%M:%S'
      end
    end

    format.gsub(/%-?[HkIlPpMSnt%]/) do |token|
      case token
      when '%H'
        zero_pad(hour)
      when '%k'
        blank_pad(hour)
      when '%-H', '%-k'
        hour
      when '%I'
        zero_pad(twelve_hour)
      when '%l'
        blank_pad(twelve_hour)
      when '%-I', '%-l'
        twelve_hour
      when '%P'
        am? ? 'am' : 'pm'
      when '%p'
        am? ? 'AM' : 'PM'
      when '%M'
        zero_pad(min)
      when '%-M'
        min
      when '%S'
        zero_pad(sec)
      when '%-S'
        sec
      when '%n'
        "\n"
      when '%t'
        "\t"
      when '%%'
        '%'
      end
    end
  end

  def succ
    self + 1
  end

  def to_a
    [hour, min, sec]
  end

  def to_f
    @seconds_since_midnight.to_f
  end

  def to_i
    @seconds_since_midnight
  end
  alias_method :tv_sec, :to_i

  def to_s
    strftime('%T')
  end
  alias_method :asctime, :to_s
  alias_method :ctime,   :to_s
  alias_method :inspect, :to_s

  private

  def mod_by_day(seconds)
    seconds % SECONDS_PER_DAY
  end

  def twelve_hour
    hour > 12 ? hour % 12 : hour
  end

  def zero_pad(number)
    number < 10 ? "0#{number}" : number
  end

  def blank_pad(number)
    number < 10 ? " #{number}" : number
  end
end
