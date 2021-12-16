class Packet
  def self.from_bit_stream(bit_stream)
    version = bit_stream.pop(3).bit_array_to_i
    type_id = bit_stream.pop(3).bit_array_to_i

    case type_id
    when 4
      LiteralValue.from_bit_stream(version, type_id, bit_stream)
    else
      Operator.from_bit_stream(version, type_id, bit_stream)
    end
  end
end
