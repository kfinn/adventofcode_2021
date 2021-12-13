require 'active_support/all'
require './diagnostic_report'
require './column_summary'

File.open('day_3_input.txt') do |file|
# File.open('day_3_input_small.txt') do |file|
  diagnostic_report = DiagnosticReport.from_file(file)
  puts "gamma: #{diagnostic_report.gamma_rate}\tepsilon: #{diagnostic_report.epsilon_rate}\tpower consumption: #{diagnostic_report.power_consumption}"
end
