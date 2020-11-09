class SimctlQueryBuilderSpy
  attr_accessor :command_passed
  attr_accessor :arg1_passed
  attr_accessor :arg2_passed

  def build_command(command, arg1 = nil, arg2 = nil)
    @command_passed = command
    @arg1_passed = arg1
    @arg2_passed = arg2
  end
end
