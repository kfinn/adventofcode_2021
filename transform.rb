class Transform
  def initialize(orientation, offset)
    @orientation = orientation
    @offset = offset
  end

  attr_reader :orientation, :offset

  class CompoundTransform
    def initialize(lhs, rhs)
      @lhs = lhs
      @rhs = rhs
    end

    attr_reader :lhs, :rhs

    def apply(relative_position)
      lhs.apply(rhs.apply(relative_position))
    end

    def +(other)
      CompoundTransform.new(self, other)
    end

    def to_s
      "(#{lhs} + #{rhs})"
    end
  end

  def apply(relative_position)
    relative_position.rotated_by(orientation) + offset
  end

  def +(other)
    CompoundTransform.new(self, other)
  end

  def to_s
    "#{orientation}, #{offset}"
  end
end
