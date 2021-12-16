class LiteralValue
  def self.from_bit_stream(version, type_id, bit_stream)
    value_bit_array = []
    begin
      current_padded_byte = bit_stream.pop(5)
      value_bit_array.append(*current_padded_byte.last(4))
    end until current_padded_byte.first == 0
    new(version, type_id, value_bit_array.bit_array_to_i)
  end

  def initialize(version, type_id, value)
    @version = version
    @type_id = type_id
    @value = value
  end

  attr_reader :version, :type_id, :value

  def to_s
    "(version #{version} literal value: #{value})"
  end

  alias version_numbers_sum version
end
