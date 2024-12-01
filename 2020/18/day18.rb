filename = "day18_input.txt"
equations = File.open(filename).readlines.map(&:chomp)

def calc(a, b, operation)
  [a.to_i, b.to_i].inject(&operation.to_sym)
end

def evaluate_equation(equation)
  # Evaluate all addition patterns, then all multiplication patterns
  patterns = [/\d+ \+ \d+/, /\d+ \* \d+/]
  patterns.each do |pattern|
    while equation.match(pattern) do
      equation.gsub!(pattern) do |sub_equation|
        a, op, b = sub_equation.split(' ')
        calc(a, b, op)
      end
    end
  end

  equation.to_i
end

total_sum = equations.sum do |equation|
  original_equation = equation.clone

  # Evaluate all parentheses and replace with their calculated result
  paren_pattern = /\([\d\*\+ ]+\)/
  while equation.match(paren_pattern) do
    equation.gsub!(paren_pattern) { |sub_equation| evaluate_equation(sub_equation[1...-1]) }
  end

  # Remaining equation string has no parentheses, evaluate this final equation
  result = evaluate_equation(equation)

  puts "#{original_equation} = #{result}"

  result
end

puts "Total sum: #{total_sum}"
