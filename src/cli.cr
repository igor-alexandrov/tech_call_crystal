require "option_parser"
require "benchmark"

require "./tech_call_crystal"

OptionParser.parse do |parser|
  parser.banner = "Welcome to the Tech Call Crystal! \n
Usage: tech_call_crystal FILENAME"

  parser.on "-v", "--version", "Show version" do
    puts "version 1.0"
    exit
  end
  parser.on "-h", "--help", "Show help" do
    puts parser
    exit
  end
end

if ARGV.size != 1
  puts "Usage: tech_call_crystal FILENAME"
  exit 1
end

filename = ARGV[0]
puts "Reading from file: #{filename}"

memory_used = 0

Benchmark.bm do |x|
  x.report do
    memory_used = Benchmark.memory do
      users_stats, top_ten_tasks_stats = TechCallCrystal::Parser.new(filename).parse

      File.open("./users_stats.csv", "w") do |file|
        CSV.build(file) do |csv|
          csv.row "User", "Task", "Duration"

          users_stats.each do |user, tasks|
            csv.row user, "", ""

            tasks.each do |task, duration|
              csv.row "", task, duration
            end
          end
        end
      end

      File.open("./top_ten_tasks_stats.csv", "w") do |file|
        CSV.build(file) do |csv|
          csv.row "Task", "Duration"

          top_ten_tasks_stats.each do |task, duration|
            csv.row task, duration
          end
        end
      end
    end
  end
end

puts "Memory used: #{memory_used} Bytes"
puts "Memory used: #{memory_used / 1024} Kb"
puts "Memory used: #{memory_used / 1024 / 1024} Mb"
