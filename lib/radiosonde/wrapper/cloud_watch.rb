class Radiosonde::Wrapper::CloudWatch
  def initialize(cloud_watch, options = {})
    @cloud_watch = cloud_watch
    @options = options
  end

  def alarms
    Radiosonde::Wrapper::AlarmCollection.new(@cloud_watch, @options)
  end

  def modified?
    @cloud_watch.modified?
  end
end
