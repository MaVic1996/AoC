
def solve_first(input)
  get_adjacents(input).reduce(0){ |acc, elem| acc+=calculate_input(input, *elem)}
end

def solve_second(input)
  get_valids(input, get_adjacents(input))
end


def calculate_input(input, val, cols, row)
  matrix = input.map{|line| line.split('')}
  col_ini, col_end = cols[0]-1, cols[-1]
  # Fix cols
  col_ini = 0 if col_ini < 0
  col_end = matrix[row].length-1 if col_end == matrix[row].length

  row_ini, row_end = row-1, row+1
  #Fix rows
  row_ini = 0 if row_ini < 0
  row_end = matrix.length-1 if row_end == matrix.length
  (row_ini..row_end).each do |i|
    (col_ini..col_end).each do |j|
      next if i == row && (cols[0]...cols[-1]).include?(j)
      if matrix[i][j] != '.'
        return val.to_i 
      end
    end
  end
  0
end

def get_valids(input, pre_valids)
  matrix = input.map{|line| line.split('')}
  valids = []
  pre_valids.each do |n, cols, row|
    col_ini, col_end = cols[0]-1, cols[-1]
    # Fix cols
    col_ini = 0 if col_ini < 0
    col_end = matrix[row].length-1 if col_end == matrix[row].length

    row_ini, row_end = row-1, row+1
    #Fix rows
    row_ini = 0 if row_ini < 0
    row_end = matrix.length-1 if row_end == matrix.length
    (row_ini..row_end).each do |i|
      (col_ini..col_end).each do |j|
        next if i == row && (cols[0]...cols[-1]).include?(j)
        if matrix[i][j] == '*'
          valids << [n, [i, j]] 
          next
        end
      end
    end
  end
  valids.group_by{|v| v[1]}.select{|_, v| v.count == 2}.map{|_, v| v[0][0] * v[1][0]}.sum
end

def get_adjacents(input)
  valids = []
  input.each_with_index do |line, row|
    matches = []
    line.scan(/\d+/){ matches << Regexp.last_match }
    matches.each{ |m| valids << [m.match(0).to_i, m.offset(0), row]}
  end
  valids
end

def print_current(matrix, row_ini, row_end, col_ini, col_end)
  puts '================================'
  (row_ini..row_end).each do |i|
    (col_ini..col_end).each do |j|
      print matrix[i][j]
    end
    puts
  end
  puts
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
