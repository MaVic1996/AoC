def solve_first(input)
  board = input.map{|line| line.split('')}
  s_x, s_y = get_start(board)
  board[s_x][s_y] = 0
  beginning = get_beginning(board, s_x, s_y)
  board, current = calculate_path(board, beginning, 1)
  print_board(board)
  current
end

def solve_second(input)

end

def get_start(board)
  board.each_with_index do |line, i|
    line.each_with_index do |elem, j|
      return [i, j] if elem == 'S'
    end
  end 
end

def get_beginning(board, orig_x, orig_y)
  pre_filt = [[1, 0], [-1, 0], [0, 1], [0, -1]]
    .select{|x, y| valid_move?(board, orig_x+x, orig_y+y)}
  pre_filt.select do |x, y| 
    x == 1 && y == 0 && ['|','L','J'].include?(board[orig_x+x][orig_y]) ||
    x == -1 && y == 0 && ['|','F','+'].include?(board[orig_x+x][orig_y]) ||
    x == 0 && y== -1 && ['-','L','F'].include?(board[orig_x][orig_y+y]) ||
    x == 0 && y== 1 && ['-','J','+'].include?(board[orig_x][orig_y+y])
  end.map{|x, y| [orig_x+x, orig_y+y]}
end

def valid_move?(board, x, y)
  x.between?(0, board.length-1) && y.between?(0, board[0].length-1) &&
    board[x][y] != '.'  &&
    !(board[x][y].is_a? Numeric)
end

def calculate_path(board, beginning, current)
  #p "-----------------------------------------------------"
  #p current
  #puts
  #p beginning
  #puts
  #
  #p "-----------------------------------------------------"

  return [board, current-1] if beginning.reject(&:empty?).empty?  
  new_beginning = []
  beginning.each do |beg|
    new_beginning += get_next_pos(board, beg)
    board[beg[0]][beg[1]] = current
  end
  return calculate_path(board, new_beginning, current+1)
end

def get_next_pos(board, pos)
  x, y = pos
  next_pos = []
  case board[x][y]
  when 'J'
    next_pos += [[x-1, y], [x, y-1]].select{|x1, y1| valid_move?(board, x1, y1)}
  when 'F'
    next_pos += [[x+1, y], [x, y+1]].select{|x1, y1| valid_move?(board, x1, y1)}
  when 'L'
    next_pos += [[x-1, y],[x, y+1]].select{|x1, y1| valid_move?(board, x1, y1)}
  when '+'
    next_pos += [[x+1, y], [x, y-1]].select{|x1, y1| valid_move?(board, x1, y1)}
  when '|'
    next_pos += [[x+1, y], [x-1, y]].select{|x1, y1| valid_move?(board, x1, y1)}
  when '-'
    next_pos += [[x, y-1],[x, y+1]].select{|x1, y1| valid_move?(board, x1, y1)}
  end
  next_pos
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).gsub('7','+').split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

def print_board(board)
  board.each do |line|
    line.each do |elem|
      print "#{elem}#"
    end
    puts
  end
  puts
end

solve_both(*ARGV)
