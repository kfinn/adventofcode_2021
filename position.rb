Position = Struct.new(:row, :column) do
  def <=>(other)
    [row, column] <=> [other.row, other.column]
  end
end
