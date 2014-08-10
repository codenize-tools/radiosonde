class AWS::CloudWatch
  def modify!
    @modified = true
  end

  def modified?
    !!@modified
  end
end
