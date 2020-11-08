class SimctlQueryBuilder
  attr_accessor :base_query

  def initialize
    @base_query = %w[xcrun simctl]
  end

  def build_command(command, arg1 = nil, arg2 = nil)
    base_query.push(command)

    base_query.push(arg1) unless arg1.nil?

    base_query.push(arg2) unless arg2.nil?

    base_query.join(' ')
  end
end
