require 'active_support/all'
require './diagnostic_report'
require './column_summary'

File.open('day_3_input.txt') do |file|
# File.open('day_3_input_small.txt') do |file|
  diagnostic_report = DiagnosticReport.from_file(file)
  puts "lines: #{diagnostic_report.lines}"
  puts "gamma: #{diagnostic_report.gamma_rate}\tepsilon: #{diagnostic_report.epsilon_rate}\tpower consumption: #{diagnostic_report.power_consumption}"
  puts "oxygen generator rating: #{diagnostic_report.oxygen_generator_rating}\tCO2 scrubber rating: #{diagnostic_report.co2_scrubber_rating}\tlife support rating: #{diagnostic_report.life_support_rating}"
end
