class FishAgeDistribution
  FISH_AGE_AFTER_SPAWNING_NEW_FISH = 6
  FISH_AGE_AFTER_BEING_SPAWNED = 8

  def self.new_fish_counts_by_age_hash
    Hash.new { |hash, fish_age| hash[fish_age] = 0 }
  end

  def self.from_file(file)
    new(
      file
      .readline
      .split(",")
      .map(&:to_i)
      .each_with_object(
        new_fish_counts_by_age_hash
      ) do |fish_age, fish_counts_by_age|
        fish_counts_by_age[fish_age] += 1
      end
    )
  end

  def initialize(fish_counts_by_age)
    @fish_counts_by_age = fish_counts_by_age
  end

  attr_reader :fish_counts_by_age

  def succ
    puts "\n"
    self.class.new(
      fish_counts_by_age
        .each_with_object(
          self.class.new_fish_counts_by_age_hash
        ) do |(fish_age, fish_count), succ_fish_counts_by_age|
          puts "#{fish_age}: #{fish_count}"
          if fish_age == 0
            succ_fish_counts_by_age[FISH_AGE_AFTER_SPAWNING_NEW_FISH] += fish_count
            succ_fish_counts_by_age[FISH_AGE_AFTER_BEING_SPAWNED] += fish_count
          else
            succ_fish_counts_by_age[fish_age - 1] += fish_count
          end
        end
    )
  end

  def total_fish_count
    fish_counts_by_age.values.sum
  end
end
