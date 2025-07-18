require_relative 'task.rb'

class TaskList
  def initialize
    @tasks = []
  end

  def add(task)
    @tasks << task
  end

  def get(index)
      if index.is_a?(Integer) and index > 0 and index <= @tasks.size
      return @tasks[index - 1]
    else
      puts "Value given to mark_done method must be an integer and within range of tasks size."
    end
  end

  def print()
    @tasks.length.times do |i|
      puts "#" + (i + 1).to_s + ": " + @tasks[i].title + " | Done?: " + @tasks[i].done.to_s 
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

  def self.from_hash(jsonData)
    task_list = TaskList.new()

    jsonData.each do |singleEntry|
      task_list.add(Task.new(singleEntry["title"], singleEntry["description"], singleEntry["done"]))
    end

    return task_list
  end

  def to_hash()
    hashArray = []
    @tasks.each do |task|
      hashArray << {"title" => task.title, "description" => task.description, "done" => task.done}
    end

    return hashArray
  end
end