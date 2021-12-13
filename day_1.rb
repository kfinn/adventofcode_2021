require 'active_support/all'

File.open('day_1_input.txt') do |f|
# File.open('day_1_small_input.txt') do |f|
  measurement_windows = [0, 0, 0]
  previous_closed_window_total = nil
  increased_measurements_count = 0

  f.each_line.with_index do |line, index|
    measurement = line.to_i
    measurement_windows[index % 3] += measurement
    measurement_windows[(index - 1) % 3] += measurement if index >= 1
    if index >= 2
      closing_window_total = measurement_windows[(index - 2) % 3] + measurement
      if previous_closed_window_total.present? && closing_window_total > previous_closed_window_total
        increased_measurements_count += 1
      end
      previous_closed_window_total = closing_window_total
      measurement_windows[(index - 2) % 3] = 0
    end
  end

  puts "increased measurements: #{increased_measurements_count}"
end
