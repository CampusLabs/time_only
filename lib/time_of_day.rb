class TimeOfDay
  include Comparable

  SECONDS_PER_MIN  = 60
  SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN
  SECONDS_PER_DAY  = 24 * SECONDS_PER_HOUR

  def self.at(seconds)
    new(seconds)
  end

  def self.now
    time = Time.now

    new(time.hour, time.min, time.sec)
  end

  def initialize(*args)
    seconds = case args.size
      when 1 # seconds since midnight
        args.first
      when 3 # hours, minutes, seconds
        (args[0] * SECONDS_PER_HOUR) + (args[1] * SECONDS_PER_MIN) + args[2]
      else
        raise ArgumentError, "wrong number of arguments (#{args.size} for 1 or 3)"
      end

    @seconds_since_midnight = mod_by_day(seconds)
  end

  def +(seconds)
    self.class.new(mod_by_day(@seconds_since_midnight + seconds))
  end

  def -(seconds)
    self + (seconds * -1)
  end

  def ==(other)
    self.to_i == other.to_i
  end
  alias_method :eql?, :==

  def <=>(other)
    to_i <=> other.to_i
  end

  def hour
    @hour ||= @seconds_since_midnight / SECONDS_PER_HOUR
  end

  def min
    @min ||= (@seconds_since_midnight % SECONDS_PER_HOUR) / SECONDS_PER_MIN
  end

  def sec
    @sec ||= @seconds_since_midnight % SECONDS_PER_MIN
  end

  def strftime(format)
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

  def am?
    hour < 12
  end
end
