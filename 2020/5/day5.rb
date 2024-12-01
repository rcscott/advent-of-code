filename = "day5_input.txt"
boarding_passes = File.open(filename).readlines.map(&:chomp)

def get_row(row_chars, row_min, row_max)
  if row_min == row_max
    return row_min
  end

  mid = row_min + ((row_max - row_min) / 2)
  if row_chars[0] == "F"
    return get_row(row_chars[1..], row_min, mid)
  else
    return get_row(row_chars[1..], mid + 1, row_max)
  end
end

def get_col(col_chars, col_min, col_max)
  if col_min == col_max
    return col_min
  end

  mid = col_min + ((col_max - col_min) / 2)
  if col_chars[0] == "L"
    return get_col(col_chars[1..], col_min, mid)
  else
    return get_col(col_chars[1..], mid + 1, col_max)
  end
end

boarding_pass_ids = boarding_passes.map do |boarding_pass|
  row = get_row(boarding_pass[0..6], 0, 127)
  col = get_col(boarding_pass[7..], 0, 7)

  row * 8 + col
end

# Find empty seat
first_seat = boarding_pass_ids.sort!.first
last_seat = boarding_pass_ids.last

possible_seats = (first_seat..last_seat).to_a
empty_seats = possible_seats.difference(boarding_pass_ids)

empty_seats.each do |empty_seat|
  if boarding_pass_ids.index(empty_seat - 1) && boarding_pass_ids.index(empty_seat + 1)
    puts empty_seat
  end
end
