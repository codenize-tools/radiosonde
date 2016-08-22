class Aws::CloudWatch::Client
  def modify!
    @modified = true
  end

  def modified?
    !!@modified
  end
end
