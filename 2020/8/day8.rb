require 'set'

filename = "day8_input.txt"
instructions = File.open(filename).readlines.map(&:chomp)

def does_instruction_set_terminate(instruction_set)
  executed_lines = Set.new
  current_line = 0
  accumulator = 0

  loop do
    statement, increment = instruction_set[current_line].split(" ")
    # puts "#{current_line}: #{statement}, #{increment} - #{accumulator}"

    case statement
    when "nop"
      current_line += 1
    when "acc"
      accumulator += increment.to_i
      current_line += 1
    when "jmp"
      current_line += increment.to_i
    end

    if executed_lines.include?(current_line)
      # infinite loop, break
      return false
    elsif current_line == instruction_set.length
      puts "Finished instruction set with accumulator value #{accumulator}"
      return true
    else
      executed_lines.add(current_line)
    end
  end
end

instructions.each_index do |i|
  next if instructions[i].include?("acc")

  modified_instructions = instructions.clone
  if modified_instructions[i].include?("nop")
    modified_instructions[i] = modified_instructions[i].gsub(/nop/, "jmp")
  else
    modified_instructions[i] = modified_instructions[i].gsub(/jmp/, "nop")
  end

  break if does_instruction_set_terminate(modified_instructions)
end
