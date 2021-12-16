require 'active_support/all'
require './fish_age_distribution'

File.open('day_6_input.txt') do |file|
# File.open('day_6_input_small.txt') do |file|
  initial_fish_age_distribution = FishAgeDistribution.from_file(file)
  fish_age_distribution = initial_fish_age_distribution
  80.times { fish_age_distribution = fish_age_distribution.succ }
  puts fish_age_distribution.fish_counts_by_age
  puts fish_age_distribution.total_fish_count

  fish_age_distribution = initial_fish_age_distribution
  256.times { fish_age_distribution = fish_age_distribution.succ }
  puts fish_age_distribution.fish_counts_by_age
  puts fish_age_distribution.total_fish_count
end
