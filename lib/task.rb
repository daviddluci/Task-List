class Task
  attr_accessor :title, :description, :done

  def initialize(title = "No title", description = "No description", done = false)
    @title = title
    @description = description
    @done = done
  end

  def print
    puts @title + " | " + @description + " | " + @done.to_s
  end
end