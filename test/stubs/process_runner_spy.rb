class ProcessRunnerSpy
  attr_accessor :create_process_command_passed
  def create_process(command)
    @create_process_command_passed = command
  end

  def wait_process_execution(process) end
end
