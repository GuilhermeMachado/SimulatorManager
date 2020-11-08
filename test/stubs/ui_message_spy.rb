require 'colorize'

class UIMessageSpy
  attr_accessor :show_error_message_passed
  attr_accessor :show_success_message_passed
  attr_accessor :show_warning_message_passed

  def show_error_message(message)
    @show_error_message_passed = message
  end

  def show_success_message(message)
    @show_success_message_passed = message
  end

  def show_warning_message(message)
    @show_warning_message_passed = message
  end
end
