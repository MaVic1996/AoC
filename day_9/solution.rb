
POSITION_MAP ={
  R: [1, 0],
  L: [-1, 0],
  U: [0, 1],
  D: [0, -1]
}

def solve_1(file_path)
  commands = File.read(file_path).split("\n").map(&:split).map{|dir, steps| [dir, steps.to_i]}
  build_path(commands)
end

def build_path(commands)
  visited_path = []
  h_position = POSITION_MAP[commands[0][0].to_sym]
  t_position = [0, 0]
  commands[0] = [commands[0][0], commands[0][1]-1]
  visited_path << t_position
  commands.each do |command|
    direction = command[0]
    steps = command[1].to_i
    steps.times do
      x, y = POSITION_MAP[direction.to_sym]
      h_position = [h_position[0]+x, h_position[1]+y]
      t_position = calculate_t_pos(t_position, h_position, visited_path)
    end
  end
  visited_path
end

def calculate_t_pos(t_pos, h_pos, visited)
  tx, ty = t_pos
  hx, hy = h_pos
  new_pos = []
  if ty==hy
    new_pos = [(tx+hx)/2, ty]
  elsif tx==hx
    new_pos = [tx, (ty+hy)/2]
  else
    if (hx - tx).abs == 1 && (hy - ty).abs == 1
      new_pos = [tx, ty]
    else
      new_pos = calculate_movement(t_pos, h_pos)
    end
  end
  visited << new_pos unless visited.include?(new_pos)
  new_pos
end

def calculate_movement(t_pos, h_pos)
  tx, ty = t_pos
  hx, hy = h_pos
  if (hx - tx).abs > (hy - ty).abs
    return [(hx-tx)/2, hy]
  else
    return [hx, (hy-ty)/2]
  end
end