class Array
  def bit_array_to_i
    reduce(0) do |value, bit|
      (value * 2) + bit
    end
  end
end
