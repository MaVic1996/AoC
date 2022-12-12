

def solve_1(file_path)
  lines = File.read(file_path).split("\n")
  calculate_signal_strength(20, 40, lines).sum
end

def solve_2(file_path)
  lines = File.read(file_path).split("\n")
  draw_CRT(lines)
end

def calculate_signal_strength(start_metric, steps, commands)
  x_val = 1
  cycle_val = 0
  signal_measures = []
  for idx in 0..commands.length
    command = commands[idx]
    cycle_val += 1
    if (cycle_val-start_metric) % steps == 0
      signal_measures << cycle_val * x_val 
    end
    if !command.nil? && command.include?('addx')
      cycle_val += 1
      if (cycle_val-start_metric) % steps == 0
        signal_measures << cycle_val * x_val if (cycle_val-start_metric) % steps == 0
      end
      x_val = x_val + command.split(' ')[1].to_i
    end
  end
  signal_measures
end

def draw_CRT(commands)
  x_val = 1
  cycle_val = 0
  crt_line = 40.times.map{|_| '.'}
  for idx in 0..commands.length
    crt_line[cycle_val%40] = '#' if [x_val-1, x_val, x_val+1].include?(cycle_val%40)
    command = commands[idx]
    cycle_val += 1    
    if cycle_val%40 == 0
      puts crt_line.join('')
      crt_line = 40.times.map{|_| '.'}
    end
    if !command.nil? && command.include?('addx')
      crt_line[cycle_val%40] = '#' if [x_val-1, x_val, x_val+1].include?(cycle_val%40)
      cycle_val += 1
      if cycle_val%40 == 0
        puts crt_line.join('')
        crt_line = 40.times.map{|_| '.'}
      end
      x_val = x_val + command.split(' ')[1].to_i
    end
  end
end
