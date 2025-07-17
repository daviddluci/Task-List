require_relative 'lib/task_list'
require_relative 'lib/task'
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
      choice = @prompt.select("\nWhat would you like to do?\n", ["View Tasks Of Previous Days", "Create new Task List", "Exit"])

      case choice
      when "View Task List Of Previous Day"
        puts "\nEnter the date for the Task List in the format of: YYYY-MM-DD.json\n"
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
          puts "\n\nError: No file found with name - " + file
        end

        puts "\n\n\n"

      when "Create new Task List"
        list = TaskList.new()
        loop do
          
          taskChoice = @prompt.select("\nWhat would you like to do?\n", ["View Tasks", "Add new task", "Mark Task Done", "Delete Task", "Exit"])

          case taskChoice
          when "View Tasks"
            clear_console()
            list.print()
          when "Add new task"
            clear_console()
            title = @prompt.ask("Enter task title: ")
            description = @prompt.ask("Enter task description: ")
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
          when "Exit"
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

end

ui = ConsoleBasedUI.new
ui.start
