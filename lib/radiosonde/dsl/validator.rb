module Radiosonde::DSL::Validator
  def _required(name, value)
    invalid = false

    if value
      case value
      when String
        invalid = value.strip.empty?
      when Array, Hash
        invalid = value.empty?
      end
    elsif value.nil?
      invalid = true
    end

    raise _identify("`#{name}` is required") if invalid
  end

  def _call_once(method_name)
    @called ||= []

    if @called.include?(method_name)
      raise _identify("`#{method_name}` is already defined")
    end

    @called << method_name
  end

  def _expected_type(value, *types)
    unless types.any? {|t| value.kind_of?(t) }
      raise _identify("Invalid type: #{value}")
    end
  end

  def _validate(errmsg)
    raise _identify(errmsg) unless yield
  end

  def _identify(errmsg)
    if @error_identifier
      errmsg = "#{@error_identifier}: #{errmsg}"
    end

    return errmsg
  end
end
