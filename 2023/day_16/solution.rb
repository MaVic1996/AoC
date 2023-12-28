DIRECTIONS= {
  right: [0, 1],
  left: [0, -1],
  up: [-1, 0],
  down: [1, 0]
}.freeze

def solve_first(input)
  board = input.map{ |line| line.split('') }
  direction = DIRECTIONS[:right]
  curr_point = [0, 0]
  get_path(board, direction, curr_point, Set.new)
end

def solve_second(input)

end

def get_path(board, direction, origin, visited)

  paths = [[origin, direction]]
  while paths.length > 0 
    origin, direction = paths.shift
    row, col = origin
    while valid_cell(board, row, col)
      sleep(1)
      visited.add([row, col]) unless exists?(visited, row, col)
      row+=direction[0]
      col+=direction[1]
      if valid_cell(board, row, col) && board[row][col] != '.'
        paths+= new_dirs(board, row, col, direction)
        break
      end
      represent_visited(board, visited)
    end
  end
  visited.size
end

def represent_visited(board, visited)
  board.each_with_index do |row, idx|
    row.each_with_index do |cell, jdx|
      if exists?(visited, idx, jdx)
        print "# "
      else
        print "#{cell} "
      end
    end
    print "\n"
  end
  print "\n==========================\n"
end

def new_dirs(board, row, col, direction)
  cell = board[row][col]
  directions = []
  case cell
  when '|'
    directions << DIRECTIONS[:up] unless direction == DIRECTIONS[:down]
    directions << DIRECTIONS[:down] unless direction == DIRECTIONS[:up]
  when '-'
    directions << DIRECTIONS[:right] unless direction == DIRECTIONS[:left]
    directions << DIRECTIONS[:left] unless direction == DIRECTIONS[:right]
  when '/'
    directions << {
      DIRECTIONS[:up] => DIRECTIONS[:right],
      DIRECTIONS[:left] => DIRECTIONS[:down],
      DIRECTIONS[:right] => DIRECTIONS[:up],
      DIRECTIONS[:down] => DIRECTIONS[:left]
    }[direction]
  when '\\'
    directions << {
      DIRECTIONS[:up] => DIRECTIONS[:left],
      DIRECTIONS[:right] => DIRECTIONS[:down],
      DIRECTIONS[:left] => DIRECTIONS[:up],
      DIRECTIONS[:down] => DIRECTIONS[:right]
    }[direction]
  end
  directions.map{|dir| [[row, col], dir]}
end

def valid_cell(board, row, col)
  row.between?(0, board.length-1) && col.between?(0, board[row].length-1)
end

def exists?(list, row, col)
  list.select{|el| el == [row, col]}.length == 1
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
