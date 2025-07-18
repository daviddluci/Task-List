require_relative 'lib/task_list'
require_relative 'lib/task'
require_relative 'db/mongo_client'
require 'tty-prompt'
require 'json'
require 'date'
require 'mongo'
require 'dotenv/load'
require 'colorize'

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
#mongodb+srv://daviddluci:123@cluster0.mmrmrcb.mongodb.net/Tasks?retryWrites=true&w=majority&appName=Cluster0
  def remote_mode
    uriProvided = @prompt.select("\nDid you specify your db uri in .env ?", ["Yes", "No"])
    uri = ""
    case uriProvided
    when "No"
      uri = @prompt.ask("Enter the uri for the db: ", required: true)
      client = MongoConnector.client(uri)
      if client.nil?
        return
      end
    when "Yes"
      puts "\nConnecting to MongoDB....".yellow()
      client = MongoConnector.client()
    end

    db = client.database
    collection = db[:task_list]

    loop do
      choice = @prompt.select("\nWhat would you like to do?\n", ["View Contents of Remote Database (MongoDB)", "Add new task", "Mark Task Done", "Delete Task", "Exit"])

      case choice
      when "View Contents of Remote Database (MongoDB)"
        collection.find.each do |document|
          puts document
        end
      when "Add new task"
        title = @prompt.ask("Title: ", required: true)
        description = @prompt.ask("Description: ", required: true)
        collection.insert_one({ title: title, description: description, done: false})
      when "Mark Task Done"
        title = @prompt.ask("Title: ", required: true)
        result = collection.find_one_and_update({ title: title }, { '$set' => { done: true } })
        if result
          puts "Task marked as done.".green
        else
          puts "No task found with title '#{title}'.".red
        end
      when "Delete Task"
        title = @prompt.ask("Title: ", required: true)
        result = collection.delete_one({ title: title })

        if result.deleted_count > 0
          puts "Task '#{title}' deleted successfully.".green
        else
          puts "No task found with title '#{title}'.".red
        end
      when "Exit"
        break
      end
    end
  end

  def start
    select_mode()
    @mode == "local" ? local_mode() : remote_mode() 
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
