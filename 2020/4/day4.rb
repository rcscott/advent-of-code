filename = "day4_input.txt"
passport_data = File.open(filename).readlines.map(&:chomp)

field_criteria = {
  "byr" => ->(x) { x.length == 4 && x.to_i >= 1920 && x.to_i <= 2002 },
  "iyr" => ->(x) { x.length == 4 && x.to_i >= 2010 && x.to_i <= 2020 },
  "eyr" => ->(x) { x.length == 4 && x.to_i >= 2020 && x.to_i <= 2030 },
  "hgt" => ->(x) { (x[-2..] == "cm" && x[0..-3].to_i >= 150 && x[0..-3].to_i <= 193) || (x[-2..] == "in" && x[0..-3].to_i >= 59 && x[0..-3].to_i <= 76) },
  "hcl" => ->(x) { x =~ /^#[0-9a-f]{6}$/ },
  "ecl" => ->(x) { ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"].include?(x) },
  "pid" => ->(x) { x =~ /^\d{9}$/ },
}

passports = [{}]
passport_data.each do |line|
  if line.length.zero?
    passports.push({})
  else
    fields = line.split(" ").map { |field| field.split(":") }.to_h
    passports.last.merge!(fields)
  end
end

valid_passports = passports.count do |passport|
  field_criteria.keys.all? do |field|
    passport.key?(field) && field_criteria[field].call(passport[field])
  end
end

puts "Valid passports: #{valid_passports}"
