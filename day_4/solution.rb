
def solve_1(file_path)
  File.read(file_path).split("\n").map{|pairs| check_fully_contain(pairs.split(','))}.sum
end

def solve_2(file_path)
  File.read(file_path).split("\n").map{|pairs| check_overlap(pairs.split(','))}.sum
end


def check_fully_contain(pairs)
  arr1, arr2 = obtain_arrs(pairs)
  (arr1 - arr2).empty? || (arr2 - arr1).empty? ? 1 : 0
end

def check_overlap(pairs)
  arr1, arr2 = obtain_arrs(pairs)
  arr1 & arr2 == [] ? 0 : 1
end

def obtain_arrs(pairs)
  pair1, pair2 = pairs
  arr1 = (pair1.split('-')[0]..pair1.split('-')[1]).to_a
  arr2 = (pair2.split('-')[0]..pair2.split('-')[1]).to_a
  [arr1, arr2]
end