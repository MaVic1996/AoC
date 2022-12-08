
def solve_1(file_path)
  matrix = File.read(file_path).gsub("\r", '').split("\n").map{|line| line.chars.map(&:to_i)}
  calculate_visibles(matrix)
end

def solve_2(file_path)
  matrix = File.read(file_path).gsub("\r", '').split("\n").map{|line| line.chars.map(&:to_i)}
  calculate_scenic_score(matrix)
end


def calculate_visibles(matrix)
  edge_visibles = matrix.length * 2 + (matrix[0].length - 2) * 2
  rest_visibles = 0
  for i in 1..matrix.length-2
    for j in 1..matrix[i].length-2
      rest_visibles += 1 if check_visible(i, j, matrix)
    end
  end
  return rest_visibles + edge_visibles
end

def calculate_scenic_score(matrix)
  visible_positions = []
  for i in 1..matrix.length-2
    for j in 1..matrix[i].length-2
      visible_positions << [i, j] if check_visible(i, j, matrix)
    end
  end
  visible_positions.map{|row_idx, column_idx| scenic_score(row_idx, column_idx, matrix)}
end

def scenic_score(row_idx, column_idx, matrix)
  value = matrix[row_idx][column_idx]

  up = calculate_score(matrix.transpose[column_idx][0...row_idx].reverse, value)
  down = calculate_score(matrix.transpose[column_idx][row_idx+1..], value)
  left = calculate_score(matrix[row_idx][0...column_idx].reverse, value)
  right = calculate_score(matrix[row_idx][column_idx+1..], value)
  up * down * left * right
end


def calculate_score(list, value)
  score = 0
  list.each do |val|
    score += 1
    return score if val >= value 
  end
  return [score,1].max
end


def check_visible(row_idx, column_idx, matrix)
  value = matrix[row_idx][column_idx]
  row_visible = matrix[row_idx][0...column_idx].max < value || matrix[row_idx][column_idx+1..].max < value
  column_visible = matrix.transpose[column_idx][0...row_idx].max < value || matrix.transpose[column_idx][row_idx+1..].max < value

  return row_visible || column_visible
end