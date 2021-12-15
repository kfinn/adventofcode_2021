Position = Struct.new(:row, :column) do
  def to_s
    "(#{row}, #{column})"
  end
end
