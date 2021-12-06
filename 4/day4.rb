class BingoBoard
  attr_accessor :complete

  def initialize(raw_rows)
    @complete = false
    @rows = []
    @columns = []

    raw_rows.each do |row|
      row = row.split(' ').map(&:to_i)
      @rows << row

      if @columns.empty?
        @columns = row.map { |num| [num] }
      else
        row.each_with_index do |num, index|
          @columns[index] << num
        end
      end
    end
  end

  def mark_number(draw_number)
    @rows.map! { |row| row - [draw_number] }
    @columns.map! { |col| col - [draw_number] }
  end

  def is_winner?
    @rows.any?(&:empty?) || @columns.any?(&:empty?)
  end

  def unmarked_tally
    @rows.flatten.inject(:+)
  end
end

data = File.open('input.txt').readlines.map(&:chomp)

draw_numbers = data.shift.split(',').map(&:to_i)

data.shift # blank line

game_boards = []
current_board_raw = []
loop do
  line = data.shift

  if line.nil? || line.empty?
    game_boards << BingoBoard.new(current_board_raw)
    current_board_raw = []
  else
    current_board_raw << line
  end

  break if line.nil?
end

winning_boards = []
draw_numbers.each do |draw_number|
  game_boards.each do |board|
    next if board.complete

    board.mark_number(draw_number)
    if board.is_winner?
      if winning_boards.empty?
        puts "First board to win:"
        puts draw_number * board.unmarked_tally
      end

      winning_boards << board
      board.complete = true
    end
  end

  if game_boards.length == winning_boards.length
    puts "Last board to win:"
    puts draw_number * winning_boards.last.unmarked_tally
    return
  end
end
