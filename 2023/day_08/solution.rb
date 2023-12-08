def solve_first(input)
  instructions = parse_instructions(input[0])
  board = parse_board(input[2..-1])

  steps = 0
  current = 'AAA'
  while current != 'ZZZ'
    instruction = instructions[steps%instructions.length]
    current = board[current][instruction.to_i]
    steps+=1
  end
  steps
end

def solve_second(input)
  instructions = parse_instructions(input[0])
  board = parse_board(input[2..-1])

  currents = board.select{|k,_| k.end_with?('A')}.keys
  steps = currents.map do |current|
    steps = 0
    while !current.end_with?('Z')
      instruction = instructions[steps%instructions.length]
      current = board[current][instruction.to_i]
      steps+=1
    end
    steps
  end
  steps.reduce(1, :lcm)
end

def parse_instructions(input)
  input.gsub('L', '0').gsub('R', '1')
end

def parse_board(board_data)
  board_data.map do |line|
    key, options = line.split(' = ')
    options = options.gsub(/\(|\)/, '').split(', ')
    [key, options]
  end.to_h
end

def end_path?(currents)
  currents.all?{|current| current.end_with?('Z')}
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
