class SnailfishNumber
  def self.from_io(snailfish_number_io)
    first_character = snailfish_number_io.readchar
    if first_character == '['
      left = from_io(snailfish_number_io)
      raise "invalid snailfish number: expected ," if left.is_pair? && snailfish_number_io.readchar != ","
      right = from_io(snailfish_number_io)
      raise "invalid snailfish number: expected ," if right.is_pair? && snailfish_number_io.readchar != "]"

      new(left, right)
    else
      regular_number_value_string = ""
      next_character = first_character
      begin
        regular_number_value_string += next_character
        next_character = snailfish_number_io.readchar
      end while next_character != ',' && next_character != ']'

      RegularNumber.new(regular_number_value_string.to_i)
    end
  end

  def initialize(left, right)
    self.left = left
    self.right = right
  end

  attr_reader :left, :right

  def left=(new_left)
    @left = new_left
    new_left.parent = self
  end

  def right=(new_right)
    @right = new_right
    new_right.parent = self
  end

  attr_accessor :parent

  def is_pair?
    true
  end

  def is_regular_number?
    false
  end

  def +(other)
    self.class.new(
      dup,
      other.dup
    ).tap(&:reduce!)
  end

  def reduce!
    begin
      needed_reduce = explode_if_necessary! || split_if_necessary!
    end while needed_reduce
  end

  def dup
    self.class.new(
      left.dup,
      right.dup
    )
  end

  def to_s
    "[#{left},#{right}]"
  end

  def needs_explode?
    needs_explode_locally? || left.needs_explode? || right.needs_explode?
  end

  def explode_if_necessary!
    if needs_explode_locally?
      nearest_left_regular_number = find_nearest_left_regular_number
      nearest_left_regular_number.value += left.value if nearest_left_regular_number.present?

      nearest_right_regular_number = find_nearest_right_regular_number
      nearest_right_regular_number.value += right.value if nearest_right_regular_number.present?

      if is_left?
        parent.left = RegularNumber.new(0)
      else
        parent.right = RegularNumber.new(0)
      end

      true
    else
      left.explode_if_necessary! || right.explode_if_necessary!
    end
  end

  def split_if_necessary!
    left.split_if_necessary! || right.split_if_necessary!
  end

  def needs_explode_locally?
    depth >= 4 &&
      left.is_regular_number? &&
      right.is_regular_number?
  end

  def depth
    return 0 if parent.nil?
    parent.depth + 1
  end

  def find_nearest_left_regular_number
    if is_right?
      parent.left.find_rightmost_regular_number
    else
      parent&.find_nearest_left_regular_number
    end
  end

  def find_rightmost_regular_number
    right.find_rightmost_regular_number
  end

  def find_nearest_right_regular_number
    if is_left?
      parent.right.find_leftmost_regular_number
    else
      parent&.find_nearest_right_regular_number
    end
  end

  def find_leftmost_regular_number
    left.find_leftmost_regular_number
  end

  def is_left?
    self == parent&.left
  end

  def is_right?
    self == parent&.right
  end

  def magnitude
    (3 * left.magnitude) + (2 * right.magnitude)
  end
end
