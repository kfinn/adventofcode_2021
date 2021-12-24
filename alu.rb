class Alu
  REGISTER_NAMES = Set.new(["w", "x", "y", "z"])

  def read(register)
    registers[register]
  end

  def write(register, value)
    registers[register] = value
  end

  def registers
    @registers ||= REGISTER_NAMES.each_with_object({}) do |register, acc|
      acc[register] = 0
    end
  end

  def run(instructions, input)
    instructions.each do |instruction|
      instruction.run(self, input)
    end
  end

  def reset!
    registers.clear
    REGISTER_NAMES.each do |register|
      registers[register] = 0
    end
  end
end
