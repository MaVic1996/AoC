def solve_first(input)
  race_times = input[0].scan(/\d+/).map(&:to_i)
  distances = input[1].scan(/\d+/).map(&:to_i)
  counts = []
  race_times.each_with_index do |time, i| 
    arr_time = time.times.to_a[1..-1]
    count = 0
    arr_time.each_with_index do |t, j|
      count+=1 if t * arr_time[-j-1] > distances[i]
    end
    counts << count
  end
  counts.reduce(:*)
end

def solve_second(input)
  race_times = input[0].scan(/\d+/).join('').to_i
  distances = input[1].scan(/\d+/).join('').to_i
  arr_time = race_times.times.to_a[1..-1]
  count = 0
  arr_time.each_with_index do |t, i|
    count+=1 if t * arr_time[-i-1] > distances
  end
  count
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both *ARGV
