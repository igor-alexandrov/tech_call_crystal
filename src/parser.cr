require "csv"
require "./row"
require "./stats_builder"

class TechCallCrystal::Parser
  def initialize(@filename : String)
    @stats_builder = TechCallCrystal::StatsBuilder.new
  end

  def parse
    File.open(@filename) do |file|
      csv = CSV.new file, headers: true

      while csv.next
        row = TechCallCrystal::Row.new(
          csv["user_id"].to_i,
          csv["task_id"].to_i,
          csv["work_duration"].to_i,
          Time.parse_utc(csv["date"], "%F"),
          csv["comment"]
        )

        @stats_builder.push row
      end
    end

    {@stats_builder.users_stats, @stats_builder.top_ten_tasks_stats}
  end
end
