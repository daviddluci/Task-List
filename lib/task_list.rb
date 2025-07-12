require_relative 'task.rb'

class TaskList
  def initialize
    @tasks = []
  end

  def add(task)
    @tasks << task
  end

  def print
    @tasks.length.times do |i|
      puts "#" + i.to_s + ": " + @tasks[i].title + " | Done?: " + @tasks[i].done.to_s 
    end
  end

  def mark_done(index)
    if index.is_a?(Integer) and index > 0  and index <= @tasks.size
      @tasks[index - 1].done = true
    else
      puts "Value given to mark_done method must be an integer and within range of tasks size."
    end
  end

  def delete(index)
    if index.is_a?(Integer) and index > 0  and index <= @tasks.size
      @tasks.delete_at(index - 1)
    else 
      puts "Value given to delete method must be an integer and within range of tasks size."
    end
  end
end