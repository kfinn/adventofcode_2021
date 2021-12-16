class BitStream
  BIT_ARRAYS_BY_HEX_CHAR = {
    '0' => [0, 0, 0, 0],
    '1' => [0, 0, 0, 1],
    '2' => [0, 0, 1, 0],
    '3' => [0, 0, 1, 1],
    '4' => [0, 1, 0, 0],
    '5' => [0, 1, 0, 1],
    '6' => [0, 1, 1, 0],
    '7' => [0, 1, 1, 1],
    '8' => [1, 0, 0, 0],
    '9' => [1, 0, 0, 1],
    'A' => [1, 0, 1, 0],
    'B' => [1, 0, 1, 1],
    'C' => [1, 1, 0, 0],
    'D' => [1, 1, 0, 1],
    'E' => [1, 1, 1, 0],
    'F' => [1, 1, 1, 1]
  }

  def initialize(io)
    @io = io
  end
  
  attr_reader :io

  def buffer
    @buffer ||= []
  end

  def hydrate_buffer(n)
    while buffer.size < n
      buffer.append(*(BIT_ARRAYS_BY_HEX_CHAR[io.readchar]))
    end
  end

  def peek(n = nil)
    if n.nil?
      hydrate_buffer(1)
      buffer.first
    else
      hydrate_buffer(n)
      buffer.first(n)
    end
  end

  def pop(n = nil)
    if n.nil?
      hydrate_buffer(1)
      buffer.shift
    else
      hydrate_buffer(n)
      buffer.shift(n)
    end
  end

  def flush_trailing_zeroes!
    raise "buffer includes some trailing non-zero values: #{buffer}" if buffer.any? { |v| v != 0 }
    buffer.clear
  end
end
