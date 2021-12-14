require 'active_support/all'
require './polymer'

File.open('day_14_input.txt') do |file|
# File.open('day_14_input_small.txt') do |file|
  initial_polymer = Polymer.from_file(file)
  polymer = initial_polymer
  40.times { polymer = polymer.succ }

  puts polymer.elements_distribution

  most_frequent_element = polymer.most_frequent_element
  most_frequent_element_frequency = polymer.elements_distribution[polymer.most_frequent_element]
  puts "most frequent element: #{most_frequent_element} (#{most_frequent_element_frequency} times)"
  least_frequent_element = polymer.least_frequent_element
  least_frequent_element_frequency = polymer.elements_distribution[polymer.least_frequent_element]
  puts "least frequent element: #{least_frequent_element} (#{least_frequent_element_frequency} times)"
  puts "result: #{most_frequent_element_frequency - least_frequent_element_frequency}"
end
