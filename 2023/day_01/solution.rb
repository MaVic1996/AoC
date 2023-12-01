def solve_1(file_path = './input.txt')
  File.read(file_path).split("\n").map do |line|
    numbers = line.split('').select { |elem| elem.match(/[[:digit:]]/) }
    (numbers[0] + numbers[-1]).to_i
  end.sum
end

def solve_2(file_path = './input.txt')
  numbers = %w[zero one two three four five six seven eight nine]
  file = File.read(file_path)
  lines = file.split("\n").map do |line|
    line.to_s.gsub(/(?=(#{numbers.join('|')}))/){"#{numbers.index(Regexp.last_match(1))}"}
  end
  lines.map { |line| line.scan(/\d/) }.sum { (_1.first + _1.last).to_i }
end
