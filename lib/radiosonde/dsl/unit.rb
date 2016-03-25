class Radiosonde::DSL::Unit
  ALIASES = {
    'Seconds'          => :seconds,
    'Microseconds'     => :microseconds,
    'Milliseconds'     => :milliseconds,
    'Bytes'            => :bytes,
    'Kilobytes'        => :kilobytes,
    'Megabytes'        => :megabytes,
    'Gigabytes'        => :gigabytes,
    'Terabytes'        => :terabytes,
    'Bits'             => :bits,
    'Kilobits'         => :kilobits,
    'Megabits'         => :megabits,
    'Gigabits'         => :gigabits,
    'Terabits'         => :terabits,
    'Percent'          => :percent,
    'Count'            => :count,
    'Bytes/Second'     => :bytes_per_second,
    'Kilobytes/Second' => :kilobytes_per_second,
    'Megabytes/Second' => :megabytes_per_second,
    'Gigabytes/Second' => :gigabytes_per_second,
    'Terabytes/Second' => :terabytes_per_second,
    'Bits/Second'      => :bits_per_second,
    'Kilobits/Second'  => :kilobits_per_second,
    'Megabits/Second'  => :megabits_per_second,
    'Gigabits/Second'  => :gigabits_per_second,
    'Terabits/Second'  => :terabits_per_second,
    'Count/Second'     => :count_per_second,
    'None'             => :none,
  }

  class << self
    def conv_to_alias(unit)
      ALIASES[unit] || unit
    end

    def valid?(unit)
      ALIASES.keys.include?(unit) or ALIASES.values.include?(unit)
    end

    def normalize(unit)
      (ALIASES.respond_to?(:key) ? ALIASES.key(unit) : ALIASES.index(unit)) || unit
    end
  end # of class methods
end
