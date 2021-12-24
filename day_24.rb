require 'active_support/all'
require_relative 'alu'
require_relative 'instruction'

def test_monad(alu, program, model_number_i)
  remaining_i = model_number_i
  model_number = 14.times.with_object([]) do |_, acc|
    acc.unshift((remaining_i % 9) + 1)
    remaining_i = remaining_i / 9
  end
  alu.run(program, model_number.dup)
  puts "model number: #{model_number.join("")} => #{alu.read('z')}"
  result = alu.read('z') == 0
  alu.reset!
  result
end

File.open("day_24_input.txt") do |file|
# File.open("day_24_input_small.txt") do |file|
  program = file.each_line.filter_map do |line|
    next if line.blank?
    Instruction.from_string(line)
  end

  alu = Alu.new
  ((9 ** 14).downto(0)).each do |guess|
    break if test_monad(alu, program, guess)
  end
end
