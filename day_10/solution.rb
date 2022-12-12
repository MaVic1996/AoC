

def solve_1(file_path)
  lines = File.read(file_path).split("\n")
  calculate_signal_strength(20, 40, lines).sum
end

def calculate_signal_strength(start_metric, steps, commands)
  x_val = 1
  cycle_val = 0
  signal_measures = []
  for idx in 0..commands.length
    command = commands[idx]
    puts command if command.nil?
    if !command.nil? && command.include?('addx')
      cycle_val += 1
      if (cycle_val-start_metric) % steps == 0
      signal_measures << cycle_val * x_val if (cycle_val-start_metric) % steps == 0
    end
  end
  cycle_val += 1
  if (cycle_val-start_metric) % steps == 0
    signal_measures << cycle_val * x_val 
  end
  x_val = x_val + command.split(' ')[1].to_i if !command.nil? && command.include?('addx')
  end
  signal_measures
end
