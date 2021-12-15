class Edge
  def initialize(destination, weight)
    @destination = destination
    @weight = weight
  end

  attr_reader :destination, :weight
end
