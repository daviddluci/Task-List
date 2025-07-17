require 'tty-prompt'
require 'json'

class ConsoleBasedUI
  attr_accessor :prompt, :mode

  def initialize
    @prompt = TTY::Prompt.new
    @mode = "none"
  end

  def clear_console
    system('cls') || system('clear')
  end

  def select_mode
    run_mode = @prompt.select("\nIn which mode would you like to start?\n", ['Local Storage Mode', 'Remote Database Mode', 'Exit'])

    case run_mode
    when 'Local Storage Mode'
      @mode = 'local'
      puts "You chose Local Storage Mode."
    when 'Remote Database Mode'
      @mode = 'remote'
      puts "You chose Remote Database Mode."
    when 'Exit'
      puts "Exiting..."
    end
  end

  def local_mode
    loop do
      choice = @prompt.select("\nIn which mode would you like to start?\n", ["View Tasks Of Previous Days", "Remote Database Mode", "Exit"])

      case choice
      when "View Tasks Of Previous Days"
        puts "\nEnter the date for the task list in the format of: YYYY-MM-DD.json\n"
        file = gets.chomp()
        file = "local_data/" + file

        if File.exist?(file)
          begin
            content = File.read(file)
            parsed = JSON.parse(content)
            puts JSON.pretty_generate(parsed)
          rescue JSON::ParserError => e
            puts "Invalid JSON format: #{e.message}"
          end
        else
          puts "false"
        end
        
        break
      when 'Remote Database Mode'
        puts "looped"
      end
    end
  end

  def start
    select_mode()
    puts @mode == "local" ? local_mode() : "a" 
  end

end

ui = ConsoleBasedUI.new
ui.start
