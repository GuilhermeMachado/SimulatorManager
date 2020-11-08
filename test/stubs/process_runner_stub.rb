class ProcessRunnerStub
  attr_accessor :process_result_to_be_returned

  def initialize(process_result_to_be_returned)
    @process_result_to_be_returned = process_result_to_be_returned
  end

  def create_process(command) end

  def wait_process_execution(*)
    process_result_to_be_returned
  end
end
