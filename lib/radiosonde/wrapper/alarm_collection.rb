class Radiosonde::Wrapper::AlarmCollection
  include Radiosonde::Logger::Helper

  def initialize(cloud_watch, alarms, options = {})
    @cloud_watch = cloud_watch
    @alarms = alarms
    @options = options
  end

  def each
    @alarms.each do |alarm|
      yield(Radiosonde::Wrapper::Alarm.new(@cloud_watch, alarm, @options))
    end
  end

  def create(name, dsl)
    log(:info, 'Create Alarm', :cyan, name)
    opts = Radiosonde::Wrapper::Alarm.normalize_attrs(dsl)

    if @options[:dry_run]
      alarm = OpenStruct.new(opts.merge(:alarm_name => name))
    else
      alarm = @alarms.create(name, opts)
      @cloud_watch.modify!
    end

    Radiosonde::Wrapper::Alarm.new(@cloud_watch, alarm, @options)
  end
end
