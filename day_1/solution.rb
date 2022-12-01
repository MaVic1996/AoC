def solve_1(file_path)
  File.read(file_path).split("\n\n").map(&:split).map{|elem| elem.map(&:to_i)}.map(&:sum).max
end

def solve_2(file_path)
  File.read(file_path).split("\n\n").map(&:split).map{|elem| elem.map(&:to_i)}.map(&:sum).max(3).sum
end
