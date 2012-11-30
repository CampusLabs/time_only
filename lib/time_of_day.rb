class TimeOfDay
  VERSION = '1.0.0'

  SECONDS_PER_MIN  = 60
  SECONDS_PER_HOUR = 60 * SECONDS_PER_MIN
  SECONDS_PER_DAY  = 24 * SECONDS_PER_HOUR

  def self.at(seconds)
    new(seconds)
  end

  def self.now
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
    '%0.2d:%0.2d:%0.2d' % to_a
  end
  alias_method :asctime, :to_s
  alias_method :ctime,   :to_s
  alias_method :inspect, :to_s

  private

  def mod_by_day(seconds)
    seconds % SECONDS_PER_DAY
  end
end
