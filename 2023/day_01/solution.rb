def solve_first(input)
  input.map do |line|
    numbers = line.scan(/\d/)
    (numbers[0] + numbers[-1]).to_i
  end.sum
end

def solve_second(input)
  num_array = %w[zero one two three four five six seven eight nine]
  input.map do |line|
    numbers = line.gsub(/(?=(#{num_array.join('|')}))/){ num_array.index(Regexp.last_match(1)).to_s }.scan(/\d/)
    (numbers[0] + numbers[-1]).to_i
  end.sum
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both *ARGV
