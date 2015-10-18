class Radiosonde::DSL::Context
  include Radiosonde::DSL::Validator
  include Radiosonde::TemplateHelper

  class << self
    def eval(dsl, path, opts = {})
      self.new(path, opts) {
        eval(dsl, binding, path)
      }
    end
  end # of class methods

  attr_reader :result

  def initialize(path, options = {}, &block)
    @path = path
    @options = options
    @result = OpenStruct.new(:alarms => [])
    @alarm_names = []

    @context = Hashie::Mash.new(
      :path => path,
      :options => options,
      :templates => {}
    )

    instance_eval(&block)
  end

  private

  def template(name, &block)
    @context.templates[name.to_s] = block
  end

  def require(file)
    alarmfile = (file =~ %r|\A/|) ? file : File.expand_path(File.join(File.dirname(@path), file))

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
    _validate("Alarm `#{name}` is already defined") do
      not @alarm_names.include?(name)
    end

    @result.alarms << Radiosonde::DSL::Context::Alarm.new(@context, name, &block).result
    @alarm_names << name
  end
end
