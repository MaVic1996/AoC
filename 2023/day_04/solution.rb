def solve_first(input)
  points_acc = []
  input.each do |line|
    line = line.split(/:|\|/)
    winning, current = line[1].split(' ').map(&:to_i), line[2].split(' ').map(&:to_i)
    matchs = winning & current
    points_acc << 2**(matchs.count-1) if matchs.count > 0
  end
  points_acc.sum
end

def solve_second(input)
  scratch_map = load_originals(input)
  input.each do |line|
    line = line.split(/:|\|/)
    card, winning, current = line[0].split(' ')[1].to_i, line[1].split(' ').map(&:to_i), line[2].split(' ').map(&:to_i)
    matchs = winning & current
    from_number = card + 1
    to_number= card + matchs.count
    (from_number..to_number).each do |i|
      scratch_map[i] += 1 * scratch_map[card]
    end
  end
  scratch_map.values.sum
end

def load_originals(input)
  input.map do |line|
    line = line.split(/:|\|/)
    card = line[0].split(' ')[1].to_i
    [card, 1]
  end.to_h
end

def print_values(scratch_map)
  scratch_map.each do |key, value|
    puts "#{key}: #{value}"
  end
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
