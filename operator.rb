class Operator
  def self.from_bit_stream(version, type_id, bit_stream)
    length_type_id = bit_stream.pop
    if length_type_id == 0
      total_length_in_bits_operator_from_bit_stream(version, type_id, bit_stream)
    else
      number_of_sub_packets_immediately_contained_operator_from_bit_stream(version, type_id, bit_stream)
    end
  end

  def self.total_length_in_bits_operator_from_bit_stream(version, type_id, bit_stream)
    sub_packet_bits = bit_stream.pop(15).bit_array_to_i
    sub_packets_bit_stream = BitArrayBitStream.new(bit_stream.pop(sub_packet_bits))
    sub_packets = []
    until sub_packets_bit_stream.empty?
      sub_packets << Packet.from_bit_stream(sub_packets_bit_stream)
    end

    new(version, type_id, sub_packets)
  end

  def self.number_of_sub_packets_immediately_contained_operator_from_bit_stream(version, type_id, bit_stream)
    number_of_sub_packets = bit_stream.pop(11).bit_array_to_i
    sub_packets = number_of_sub_packets.times.map do
      Packet.from_bit_stream(bit_stream)
    end

    new(version, type_id, sub_packets)
  end

  def initialize(version, type_id, sub_packets)
    @version = version
    @type_id = type_id
    @sub_packets = sub_packets
  end

  attr_reader :version, :type_id, :sub_packets

  def to_s
    "(version #{version} operator; type_id: #{type_id}; sub_packets: #{sub_packets.map(&:to_s).join(", ")})"
  end

  def version_numbers_sum
    version + sub_packets.map(&:version_numbers_sum).sum
  end
end
