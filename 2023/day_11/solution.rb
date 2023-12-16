def solve_first(input)
  expanded = expand(input.map{|line| line.split('')})
  numbered, combinations, positions = number_board(expanded)
  sum = 0
  combinations.each do |i, j|
    ps_i = positions[i]
    ps_j = positions[j]
    sum += (ps_j[0] - ps_i[0]).abs + (ps_j[1] - ps_i[1]).abs
  end
  sum
end

def solve_second(input)
  numbered, combinations, positions = number_board(expand(input.map{|line| line.split('')}))
  input = input.map{|line| line.split('')}
  expanded_rows = input.map.with_index{|line, i|  line.include?("#") ? nil : i}.compact
  expanded_columns = input.transpose.map.with_index{|line, i|  line.include?("#") ? nil : i}.compact
  sum = 0
  combinations.each do |i, j|
    ps_i = positions[i]
    ps_j = positions[j]
    calc_x = calculate_path(expanded_rows, ps_j[0], ps_i[0])
    calc_y = calculate_path(expanded_columns, ps_j[1], ps_i[1])
    print "Compare: #{i+1}(#{ps_i}) #{j+1}(#{ps_j})\n"    
    print "Sum: #{calc_x} + #{calc_y} = #{calc_x+calc_y}\n"
    sum += calc_x + calc_y
  end
  sum
end


def calculate_path(expanded, ps_j, ps_i)
 arr_res = ps_i < ps_j ? (ps_i..ps_j).to_a : (ps_j..ps_i).to_a
 matches = arr_res & expanded
 print("Matches: #{matches}\n")
 (ps_i-ps_j).abs - (matches.length-1) + ((10-1) * matches.length)
end

def expand(board)
  board.to_enum.with_index.reverse_each do |line, i|
    board.insert(i,('.'*(board[i].length)).split(''))unless line.include?("#")
  end

  columns = []
  board.transpose.each_with_index do |line, i|
   columns << i unless line.include?("#")
  end

  columns.reverse_each do |i|
    board.each{|line| line.insert(i, '.')}
  end
  board
end

def number_board(board)
  count = 0
  positions = []
  board.each.with_index do |line, i|
    line.each.with_index do |elem, j|
      if elem == '#'
        line[j] = count 
        positions << [i, j]
        count+=1
      end
    end
  end
  combinations = (count).times.to_a.combination(2).to_a
  [board, combinations, positions]
end


def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
