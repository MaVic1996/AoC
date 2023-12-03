def solve_first(input)
  get_adjacents(input).select{ |n, cols, row| check_num_first(input, cols, row)}.map{ |valid| valid[0].to_i}.sum
end

def solve_second(input)
  get_valids(input, get_adjacents(input))
end


def check_num_first(input, cols, row)
  matrix = input.map{|line| line.split('')}
  col_ini, col_end = cols[0]-1, cols[-1]+1
  # Fix cols
  col_ini = 0 if col_ini < 0
  col_end = matrix[row].length-1 if col_end == matrix[row].length

  row_ini, row_end = row-1, row+1
  #Fix rows
  row_ini = 0 if row_ini < 0
  row_end = matrix.length-1 if row_end == matrix.length
  (row_ini..row_end).each do |i|
    (col_ini..col_end).each do |j|
      next if i == row && cols.include?(j)
      if matrix[i][j] != '.'
        return true 
      end
    end
  end
  false
end

def get_valids(input, pre_valids)
  matrix = input.map{|line| line.split('')}
  valids = []
  pre_valids.each do |n, cols, row|
    col_ini, col_end = cols[0]-1, cols[-1]+1
    # Fix cols
    col_ini = 0 if col_ini < 0
    col_end = matrix[row].length-1 if col_end == matrix[row].length

    row_ini, row_end = row-1, row+1
    #Fix rows
    row_ini = 0 if row_ini < 0
    row_end = matrix.length-1 if row_end == matrix.length
    (row_ini..row_end).each do |i|
      (col_ini..col_end).each do |j|
        next if i == row && cols.include?(j)
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
    tmp_number = ''
    line.split('').each_with_index do |char, col|
      if tmp_number == ''
        next unless char.match?(/[0-9]/)
      end
      if char.match?(/[0-9]/)
        tmp_number+=char  
      else
        valids << [tmp_number.to_i, (col - tmp_number.length).upto(col-1).to_a, row]
        tmp_number = ''
      end
    end
    valids << [tmp_number.to_i, (line.length - tmp_number.length).upto(line.length-1).to_a, row] if tmp_number != ''
  end
  valids
end

def print_current(matrix, row_ini, row_end, col_ini, col_end)
  puts "================================"
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
