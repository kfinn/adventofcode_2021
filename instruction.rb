class Inp
  def initialize(destination)
    @destination = destination
  end

  attr_reader :destination

  def run(alu, input)
    alu.write(destination, input.shift)
  end
end

module BinaryInstruction
  def initialize(destination, source)
    @destination = destination
    @source = source
  end
  attr_reader :destination, :source

  def read_destination(alu)
    alu.read(destination)
  end

  def write_destination(alu, value)
    alu.write(destination, value)
  end

  def read_source(alu)
    return alu.read(source) if source.in? Alu::REGISTER_NAMES
    source.to_i
  end
end

class Add
  include BinaryInstruction
  
  def run(alu, input)
    write_destination(alu, read_destination(alu) + read_source(alu))
  end
end

class Mul
  include BinaryInstruction
  
  def run(alu, input)
    write_destination(alu, read_destination(alu) * read_source(alu))
  end
end

class Div
  include BinaryInstruction
  
  def run(alu, input)
    write_destination(alu, read_destination(alu) / read_source(alu))
  end
end

class Mod
  include BinaryInstruction
  
  def run(alu, input)
    write_destination(alu, read_destination(alu) % read_source(alu))
  end
end

class Eql
  include BinaryInstruction
  
  def run(alu, input)
    write_destination(alu, read_destination(alu) == read_source(alu) ? 1 : 0)
  end
end

class Instruction
  def self.from_string(instruction_string)
    puts instruction_string
    instruction_parts = instruction_string.split
    instruction_class = instruction_parts.first.capitalize.constantize
    instruction_class.new(*instruction_parts[1..])
  end
end
