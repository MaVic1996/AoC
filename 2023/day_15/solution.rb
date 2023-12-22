def solve_first(input)
  input.join.split(',').reduce([]) do |acc, command|
    acc << command.each_char.reduce(0){|acc, ch| acc = ((acc+ch.ord)*17)%256}
    acc
  end.sum
end

def solve_second(input)

end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
