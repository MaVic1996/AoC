def solve_first(input)
  loads = input.each_with_index.map do |line, row_idx|
    line.split('').each_with_index.map do |char, col_idx|
      if char != 'O'
        0
      else
        load = calculate_load(row_idx, col_idx, input)
        # puts "row: #{row_idx}, col: #{col_idx} load: #{load}"
        load
      end
    end
  end
  loads.sum{|row| row.sum}
end

def calculate_load(row_idx, col_idx, input)
  down_load = input.length - row_idx 
  up_load = 0
  (0..row_idx).reverse_each do |i|
    next if input[i][col_idx] == 'O'
    break if input[i][col_idx] == '#'
    up_load += 1
  end
  # puts "------------------------------------------"
  # puts "down: #{down_load}, up: #{up_load}"
  down_load + up_load
end

def solve_second(input)

end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
