
POSITION_MAP ={
  R: [1, 0],
  L: [-1, 0],
  U: [0, 1],
  D: [0, -1]
}

def solve_1(file_path)
  commands = File.read(file_path).split("\n").map(&:split).map{|dir, steps| [dir, steps.to_i]}
  build_path(commands, 2)
end

def solve_2(file_path)
  commands = File.read(file_path).split("\n").map(&:split).map{|dir, steps| [dir, steps.to_i]}
  build_path(commands, 10)
end

def build_path(commands, knots)
  visited_path = []
  knots_position = knots.times.map{|t| [0,0]}
  commands.each do |command|
    direction = command[0]
    steps = command[1].to_i
    steps.times do
      x, y = POSITION_MAP[direction.to_sym]
      knots_position[0] = [knots_position[0][0]+x, knots_position[0][1]+y]
      knots_position = calculate_knots_position(knots_position)
      visited_path << knots_position[-1] unless visited_path.include? knots_position[-1]
    end
  end
  visited_path
end

def calculate_knots_position(knots)
  return knots if knots.length == 1
  for i in 1..knots.length-1
    knots[i] = calculate_t_pos(knots[i], knots[i-1])
  end
  knots
end


def calculate_t_pos(t_pos, h_pos)
  x_dist = (t_pos[0] - h_pos[0]).abs
  y_dist = (t_pos[1] - h_pos[1]).abs
  x, y = h_pos
  if x_dist.abs <= 1 && y_dist.abs <= 1
    return t_pos
  end
  x = (h_pos[0] + t_pos[0])/2 if x_dist.abs == 2
  y = (h_pos[1] + t_pos[1])/2 if y_dist.abs == 2 

  return [x, y]
end