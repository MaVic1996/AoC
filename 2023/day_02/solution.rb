R_LIMIT = 12
G_LIMIT = 13
B_LIMIT = 14

def solve_first(input)
  valids = []
  input.each do |line|
    game_id, game_data = line.split(':')
    game_id = game_id.split(' ')[1].to_i
    valid_data = true
    game_data.split(/;|,/).each do |data|
      quantity, color = data.split(' ')
      valid_data = false if color.include?('red') && quantity.to_i > R_LIMIT
      valid_data = false if color.include?('green') && quantity.to_i > G_LIMIT
      valid_data = false if color.include?('blue') && quantity.to_i > B_LIMIT
    end
    valids << game_id if valid_data
  end
  valids.sum
end

def solve_second(input)
  values = []
  input.each do |line|
    game_data = line.split(':')[1]
    fewest = game_data.split(/;|,/).inject({}) do |acc, data|
      quantity, color = data.split(' ')
      acc[color] = quantity.to_i if acc[color].nil? || acc[color].to_i < quantity.to_i
      acc
    end
    values << fewest.values.reduce(:*)
  end
  values.sum
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
