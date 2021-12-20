class Enhancement
  def self.from_string(enhancement_string)
    new(enhancement_string.each_char.map { |char| char == "#" ? 1 : 0 })
  end

  def initialize(array)
    @array = array
  end

  attr_reader :array
  delegate :[], to: :array

  def enhance(unenhanced_values)
    index = unenhanced_values.reduce(0) do |acc, unenhanced_value|
      acc * 2 + unenhanced_value 
    end
    self[index]
  end
end
