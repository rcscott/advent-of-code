filename = "day14_input.txt"
input = File.open(filename).readlines.map(&:chomp)

def get_memory_addresses(input_address_int, input_mask)
  x_count = input_mask.count("X")
  address_mask = "0" * x_count
  masks = [address_mask]

  while address_mask.include?("0") do
    address_mask = address_mask.to_i(2) + 1
    address_mask = format("%0#{x_count}d", address_mask.to_s(2))
    masks << address_mask
  end

  input_address = format("%036d", input_address_int.to_s(2))
  addresses = []

  masks.each do |mask|
    address = ""
    input_address.chars.each_index do |index|
      if input_mask[index] == "1"
        address << "1"
      elsif input_mask[index] == "0"
        address << input_address[index]
      else
        address << mask.slice!(0)
      end
    end
    addresses << address
  end

  addresses
end

def set_memory_value(memory, address_int, value_int, mask)
  value = format("%036d", value_int.to_s(2))
  addresses = get_memory_addresses(address_int, mask)

  addresses.each do |address|
    memory[address.to_i(2)] = value
  end
end

memory = {}
mask = ""
input.each do |line|
  if line.start_with?("mask")
    mask = line.split(" ").last
  else
    m = line.match /^mem\[(?<address>\d+)\] = (?<value_int>\d+)$/
    set_memory_value(memory, m[:address].to_i, m[:value_int].to_i, mask)
  end
end

puts "Sum of values: #{memory.values.sum(0) { |v| v.to_i(2) }}"
