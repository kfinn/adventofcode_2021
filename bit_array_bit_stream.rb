class BitArrayBitStream
  def initialize(bit_array)
    @bit_array = bit_array
  end

  attr_reader :bit_array

  def peek(n = nil)
    if n.nil?
      bit_array.first
    else
      bit_array.first(n)
    end
  end

  def pop(n = nil)
    if n.nil?
      bit_array.shift
    else
      bit_array.shift(n)
    end
  end

  delegate :empty?, to: :bit_array
end
