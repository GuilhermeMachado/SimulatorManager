require 'colorize'

class UIMessage
  def show_error_message(message)
    puts "❌   #{message}".red
  end

  def show_success_message(message)
    puts "✅   #{message}".green
  end

  def show_warning_message(message)
    puts "⚠️   #{message}".yellow
  end
end
