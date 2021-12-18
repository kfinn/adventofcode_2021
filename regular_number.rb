class RegularNumber
  def initialize(value)
    @value = value
  end

  attr_accessor :value, :parent

  def +(other)
    self.class.new(value + other.value)
  end

  def is_pair?
    false
  end

  def is_regular_number?
    true
  end

  def reduce!
    self
  end

  def needs_explode?
    false
  end

  def needs_split?
    value > 10
  end

  def explode_if_necessary!
    false
  end

  def split_if_necessary!
    return false unless value >= 10

    pair_after_split = SnailfishNumber.new(
      self.class.new((value.to_f / 2.0).floor),
      self.class.new((value.to_f / 2.0).ceil),
    )

    if is_left?
      parent.left = pair_after_split
    else
      parent.right = pair_after_split
    end
  end

  def find_leftmost_regular_number
    self
  end

  def find_rightmost_regular_number
    self
  end

  def is_left?
    self == parent&.left
  end

  def is_right?
    self == parent&.right
  end

  delegate :to_s, to: :value

  def magnitude
    value
  end
end
