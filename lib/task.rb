class Task
  attr_accessor :title, :description, :done

  def initialize(title = "No title", description = "No description")
    puts "new task created."
    @title = title
    @description = description
    @done = false
  end

  def print
    puts @title + " | " + @description + " | " + @done.to_s
  end

end