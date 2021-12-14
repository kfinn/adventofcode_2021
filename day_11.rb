require 'active_support/all'
require './octopus_grid'

File.open('day_11_input.txt') do |file|
# File.open('day_11_input_small.txt') do |file|
  octopus_grid = OctopusGrid.from_file(file)
  synchronous_flash_index = nil
  step_index = 0
  while synchronous_flash_index.blank?
    step_index += 1
    synchronous_flash_index = step_index if octopus_grid.step.size == octopus_grid.size
  end
  puts "first synchronous flash index: #{synchronous_flash_index}"
end
