class Polymer
  def self.from_file(file)
    elements = nil
    rules = {}

    file.each_line do |line|
      if elements.nil?
        elements = line.squish.each_char.to_a
      elsif line.present?
        rule_components = line.split(" -> ")
        rules[rule_components.first.squish] = rule_components.second.squish
      end
    end

    new(elements, rules)
  end

  attr_reader :elements, :rules

  def initialize(elements, rules)
    @elements = elements
    @rules = rules
  end

  def succ
    succ_elements = elements.each_with_object([]).with_index do |(element, succ_elements_builder), index|
      if index > 0
        previous_element = elements[index - 1]
        element_to_insert = rules["#{previous_element}#{element}"]
        succ_elements_builder << element_to_insert if element_to_insert.present?
      end
      succ_elements_builder << element
    end

    self.class.new(succ_elements, rules)
  end

  def least_frequent_element
    @least_frequent_element ||= elements_distribution.keys.min_by { |key| elements_distribution[key] }
  end

  def most_frequent_element
    @most_frequent_element ||= elements_distribution.keys.max_by { |key| elements_distribution[key] }
  end

  def elements_distribution
    @elements_distribution ||= elements.each_with_object(Hash.new { |hash, key| hash[key] = 0 }) do |element, distribution|
      distribution[element] += 1
    end
  end
end
