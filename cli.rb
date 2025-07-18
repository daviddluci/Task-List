require_relative 'lib/task_list'
require_relative 'lib/task'
require 'tty-prompt'
require 'json'
require 'date'

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
      choice = @prompt.select("\nWhat would you like to do?\n", ["View Tasks Of Previous Days", "Create new Task List", "Exit"])

      case choice
      when "View Tasks Of Previous Days"
        file = @prompt.ask("\nEnter the date for the Task List in the format of: YYYY-MM-DD.json\n ", required: true)
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
          puts "\n\nError: No file found with name - " + file
        end

        puts "\n\n\n"

      when "Create new Task List"
        list = TaskList.new()
        loop do
          
          taskChoice = @prompt.select("\nWhat would you like to do?\n", ["View Tasks", "Add new task", "Mark Task Done", "Delete Task", "Exit (Save)"])

          case taskChoice
          when "View Tasks"
            clear_console()
            list.print()
          when "Add new task"
            clear_console()
            title = @prompt.ask("Enter task title: ", required: true)
            description = @prompt.ask("Enter task description: ", required: true)
            list.add(Task.new(title, description))
          when "Mark Task Done"
            clear_console()
            list.print()
            id = @prompt.ask("\nWhich task? ", convert: :int)
            list.mark_done(id)
          when "Delete Task"
            clear_console()
            list.print()
            id = @prompt.ask("\nWhich task? ", convert: :int)
            list.delete(id)
          when "Exit (Save)"
            write_file(list)
            break
          end
        end
      end
    end
  end

  def start
    select_mode()
    puts @mode == "local" ? local_mode() : "a" 
  end

  def write_file(list)
    hashed_list = list.to_hash()

    File.open("local_data/#{DateTime.now().strftime("%Y-%m-%d")}.json", "w") do |file|
      file.write(JSON.pretty_generate(hashed_list))
    end
  end

end

ui = ConsoleBasedUI.new
ui.start
