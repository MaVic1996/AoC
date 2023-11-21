
def solve_1(file_path)
  File.read(file_path).split("\n").map{|items| prioritize_1(items)}.sum
end

def solve_2(file_path)
  File.read(file_path).split("\n").each_slice(3).to_a.map{|group| prioritize_2(group)}.sum
end

LOW_CASE_PRIO = ("a".ord - 1)
UPPER_CASE_PRIO = ("A".ord - 27)

def prioritize_1(items)
  comp1, comp2 = items.chars.each_slice(items.length/2).to_a 
  wrong_item = (comp1 & comp2).first
  calculate_points(wrong_item)
end

def prioritize_2(group)
  g1, g2, g3 = group.map(&:chars)
  badge = (g1 & g2 & g3).first
  calculate_points(badge)
end

def calculate_points(item)
  item.match(/[a-z]/).nil? ? item.ord - UPPER_CASE_PRIO : item.ord - LOW_CASE_PRIO
end