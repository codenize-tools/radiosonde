class Radiosonde::Wrapper::CloudWatch
  def initialize(clowd_watch, options = {})
    @clowd_watch = clowd_watch
    @options = options
  end

  def alarms
    Radiosonde::Wrapper::AlarmCollection.new(@clowd_watch, @clowd_watch.alarms, @options)
  end

  def modified?
    @clowd_watch.modified?
  end
end
