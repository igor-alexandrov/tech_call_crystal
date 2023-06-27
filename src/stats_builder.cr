class TechCallCrystal::StatsBuilder
  alias TaskStats = Hash(Int32, Int32)
  alias UserStats = Hash(Int32, TaskStats)

  property users_stats

  def initialize
    proc = ->(hash : UserStats, key : Int32) { hash[key] = TaskStats.new(0) }
    @users_stats = UserStats.new(proc)

    @tasks_stats = TaskStats.new(0)
  end

  def push(row : TechCallCrystal::Row)
    @users_stats[row.user_id][row.task_id] += row.duration
    @tasks_stats[row.task_id] += row.duration
  end

  def top_ten_tasks_stats
    @tasks_stats.invert.max(10).reduce(TaskStats.new(0)) do |hash, (duration, task_id)|
      hash[task_id] = duration
      hash
    end
  end
end
