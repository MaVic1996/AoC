
def solve_1(file_path='day_12/example.txt')
  m, sp, ep = map_matrix(File.read(file_path).gsub("\r", '').split("\n"))
  vertices, weight = create_graph(m)
  puts vertices.length
  dijkstra(vertices, weight, sp)
end

def map_matrix(matrix)
  min_val = "a".bytes.first
  max_val = "z".bytes.first
  res_matrix = []
  start_point = nil 
  destiny_point = nil
  for i in 0..matrix.length-1 do
    res_matrix << []
    for j in 0..matrix[i].length-1 do
      if matrix[i][j] == 'S'
        start_point = "#{i},#{j}"
        res_matrix[i] << 0
      elsif matrix[i][j] == 'E'
        end_point = "#{i},#{j}"
        res_matrix[i] << 2 + max_val - min_val
      else 
        res_matrix[i] << matrix[i][j].bytes.first - (min_val - 1)
      end
    end
  end
  [res_matrix, start_point, end_point]
end

def print_matrix(matrx)
  matrx.each{ |line| puts line.join("\t")}
end


def create_graph(matrx)
  vertices = create_vertices(matrx)
  weight = create_edges(vertices, matrx)
  weight.each{|l| puts "#{l.join(' ')}\n"}
  [vertices, weight]
end

def create_vertices(matrx)
  vertices = []
  for i in 0..matrx.length-1 do
    for j in 0..matrx[i].length-1 do
      vertices << "#{i},#{j}"
    end
  end
  vertices
end

def create_edges(vertices, matrx)
  max = matrx.length * matrx.length
  edges_matrix = []
  for i in 0..vertices.length-1 do
    edges_matrix << []
    for j in 0..vertices.length-1 do
      from = vertices[i]
      to = vertices[j]
      if from == to 
        edges_matrix[i] << 'F'
      else
        f_i, f_j = from.split(',').map(&:to_i)
        t_i, t_j = to.split(',').map(&:to_i)
        edges_matrix[i] << (matrx[f_i][f_j] == matrx[t_i][t_j] - 1 ? 'T' : 'F')
      end
    end
  end
  edges_matrix
end

def dijkstra(vertices, weight_matrix, start_point)
  #TODO 
end