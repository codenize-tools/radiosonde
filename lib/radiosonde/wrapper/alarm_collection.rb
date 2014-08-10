class Radiosonde::Wrapper::AlarmCollection
  include Radiosonde::Logger::Helper

  def initialize(clowd_watch, alarms, options = {})
    @clowd_watch = clowd_watch
    @alarms = alarms
    @options = options
  end

  def each
    @alarms.each do |alarm|
      yield(Radiosonde::Wrapper::Alarm.new(@clowd_watch, alarm, @options))
    end
  end

  def create(name, dsl)
    log(:info, 'Create Alarm', :cyan, name)
    opts = Radiosonde::Wrapper::Alarm.normalize_attrs(dsl)

    if @options[:dry_run]
      alarm = OpenStruct.new(opts.merge(:alarm_name => name))
    else
      alarm = @alarms.create(name, opts)
      @clowd_watch.modify!
    end

    Radiosonde::Wrapper::Alarm.new(@clowd_watch, alarm, @options)
  end
end
