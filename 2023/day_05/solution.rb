def solve_first(input)
  seeds, maps= parse_input(input, :first)
  apply_maps(seeds, maps)
end

def solve_second(input)
  seeds, maps = parse_input(input, :second)
  # seeds = seeds.reverse
  maps.each do |c_map|
    posible_seeds = []

    while seeds.length > 0 do 
      seed_start, seed_end = seeds.shift
      c_map.each do |from, to, t|
        range_start = [from, seed_start].max
        range_end = [to, seed_end].min

        next if range_start >= range_end
        posible_seeds << [range_start + t, range_end + t]
        seeds << [seed_start, range_start] if range_start > seed_start
        seeds << [range_end, seed_end] if range_end < seed_end
        break
      end
      posible_seeds << [seed_start, seed_end] if posible_seeds.empty?
    end
    seeds = posible_seeds
  end
  seeds.min[0]
end

def parse_input(input, ex)
  seeds = method("load_seeds_#{ex}").call(input[0])
  maps = []
  input[1..-1].each_with_index do |line, idx|
    maps << []
    line.split("\n")[1..-1].each do |trans_map|
      to, from, t = trans_map.split(' ').map(&:to_i)
      maps[idx] << [from, from+t-1, to-from]
    end
  end
  [seeds, maps]
end

def apply_maps(seeds, maps)
  locations = seeds.reduce(FIXNUM_MAX) do |acc, seed|
    final_seed = seed.to_i
    maps.each do |c_map|
      to_apply = c_map.select do |from, to, t|
        final_seed.between?(from, to)
      end
      final_seed += to_apply[0][2] if to_apply.any?
    end
    acc = final_seed if final_seed < acc
    acc
  end
  locations
end

def load_seeds_first(input)
  input.split(' ')[1..-1].map(&:to_i)
end

def load_seeds_second(input)
  a = input.split(' ')[1..-1].map(&:to_i).each_slice(2).to_a.map{|x|[x[0], x[0]+x[1]]}
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

def print_maps(maps)
  maps.each do |c_map|
    puts '-----------------------------------'
    c_map.each do |from, to, t|
      puts "(#{from}-#{to}) #{t}"
    end
  end
end

solve_both(*ARGV)
