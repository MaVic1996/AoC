def solve_first(input)
  valids = []
  input.each_with_index do |line, row|
    row_numbers = []
    tmp_number = ''
    line.split('').each_with_index do |char, col|
      if tmp_number == ''
        next unless char.match?(/[0-9]/)
      end
      if char.match?(/[0-9]/)
        tmp_number+=char  
      else
        row_numbers << [tmp_number.to_i, (col - tmp_number.length).upto(col-1).to_a]
        tmp_number = ''
      end
    end
    row_numbers << [tmp_number.to_i, (line.length - tmp_number.length).upto(line.length-1).to_a] if tmp_number != ''
    filtered = row_numbers.select do |n, cols|
      check_num_first(input, cols, row)
    end
    valids += filtered
  end
  valids.map{|valid| valid[0].to_i}.sum
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

def check_num_second

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

def solve_second(input)
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
