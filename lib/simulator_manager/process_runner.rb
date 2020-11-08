class ProcessRunner
  def create_process(command)
    fork { exec(command) }
  end

  def wait_process_execution(process)
    _, status = Process.waitpid2(process)
    status.success?
  end
end
