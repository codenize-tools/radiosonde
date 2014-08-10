class Radiosonde::DSL::Parser
  include Radiosonde::DSL::Validator

  class << self
    def parse(dsl, path, opts = {})
      self.new(path, opts) {
        eval(dsl, binding, path)
      }.result
    end
  end # of class methods

  attr_reader :result

  def initialize(path, options = {}, &block)
    @path = path
    @options = options
    @result = {}
    instance_eval(&block)
  end

  private

  def require(file)
    alarmfile = File.expand_path(File.join(File.dirname(@path), file))

    if File.exist?(alarmfile)
      instance_eval(File.read(alarmfile), alarmfile)
    elsif File.exist?(alarmfile + '.rb')
      instance_eval(File.read(alarmfile + '.rb'), alarmfile + '.rb')
    else
      Kernel.require(file)
    end
  end

  def alarm(name, &block)
    _required(:alarm_name, name)
    _not_defined(name, @result.keys)
    @result[name] = Radiosonde::DSL::Alarm.new(name, &block).result
  end
end
