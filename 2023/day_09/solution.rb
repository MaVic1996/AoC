def solve_first(input)
  input.map{|line| calculate_value(line.split(' ').map(&:to_i), :calc_next)}.sum
end

def solve_second(input)
  input.map{|line| calculate_value(line.split(' ').map(&:to_i), :extrapolate_prev)}.sum
end

def calculate_value(line, method)
  series = [line]
  while !series[-1].all?(&:zero?) do
    new_serie = []
    for i in 0...series[-1].length-1 do
      new_serie << series[-1][i+1] - series[-1][i]
    end
    series << new_serie
  end
  method(method).call(series)
end

def calc_next(series)
  calculated_val = 0
  series.reverse[1..].each do |serie|
    calculated_val += serie[-1]
  end
  calculated_val
end

def extrapolate_prev(series)
  calculated_val = 0
  series.reverse[1..].each_with_index do |serie, i|
    calculated_val = serie[0] - calculated_val
  end
  calculated_val
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
