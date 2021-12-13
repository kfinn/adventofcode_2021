class Fold
  class FoldAlongX
    PATTERN = /fold along x=(\d+)/

    def self.from_string(fold_string)
      new(PATTERN.match(fold_string)[1].to_i)
    end

    attr_reader :x

    def initialize(x)
      @x = x
    end

    def apply(dot)
      if dot.x > x
        Dot.new(2 * x - dot.x, dot.y)
      else
        dot
      end
    end
  end

  class FoldAlongY
    PATTERN = /fold along y=(\d+)/

    def self.from_string(fold_string)
      new(PATTERN.match(fold_string)[1].to_i)
    end

    attr_reader :y

    def initialize(y)
      @y = y
    end

    def apply(dot)
      if dot.y > y
        Dot.new(dot.x, 2 * y - dot.y)
      else
        dot
      end
    end
  end

  def self.from_string(fold_string)
    case fold_string
    when FoldAlongX::PATTERN
      FoldAlongX.from_string(fold_string)
    when FoldAlongY::PATTERN
      FoldAlongY.from_string(fold_string)
    else
      raise "invalid fold string: #{fold_string}"
    end
  end
end
