class Polymer
  def self.distribution_hash
    Hash.new { |hash, key| hash[key] = 0 }
  end

  def self.from_file(file)
    first_element = nil
    elements = nil
    rules = {}

    file.each_line do |line|
      if elements.nil?
        elements = line.squish.each_char.to_a
        first_element = elements.first
      elsif line.present?
        rule_components = line.split(" -> ")
        element_pair = rule_components.first.squish
        element_to_insert = rule_components.second.squish
        rules[element_pair] = ["#{element_pair[0]}#{element_to_insert}", "#{element_to_insert}#{element_pair[1]}"]
      end
    end

    element_pairs_distribution = 
      elements
      .each_with_object(distribution_hash)
      .with_index do |(element, element_pairs_distrubution_builder), index|
        next if index == 0

        previous_element = elements[index - 1]
        element_pair = "#{previous_element}#{element}"
        element_pairs_distrubution_builder[element_pair] += 1
      end
    
    new(first_element, element_pairs_distribution, rules)
  end

  attr_reader :first_element, :element_pairs_distribution, :rules
  
  def initialize(first_element, element_pairs_distribution, rules)
    @first_element = first_element
    @element_pairs_distribution = element_pairs_distribution
    @rules = rules
  end

  def succ
    succ_element_pairs_distribution = element_pairs_distribution.each_with_object(self.class.distribution_hash) do |(element_pair, frequency), succ_element_pairs_distribution_builder|
      rules[element_pair].each do |element_pair_to_insert|
        succ_element_pairs_distribution_builder[element_pair_to_insert] += frequency
      end
    end

    self.class.new(first_element, succ_element_pairs_distribution, rules)
  end

  def least_frequent_element
    @least_frequent_element ||= elements_distribution.keys.min_by { |key| elements_distribution[key] }
  end

  def most_frequent_element
    @most_frequent_element ||= elements_distribution.keys.max_by { |key| elements_distribution[key] }
  end

  def elements_distribution
    @elements_distribution ||=
      element_pairs_distribution
      .each_with_object(
        self.class.distribution_hash.tap do |distribution|
          distribution[first_element] += 1
        end
      ) do |(element_pair, frequency), distribution|
        distribution[element_pair[1]] += frequency
      end
  end
end
