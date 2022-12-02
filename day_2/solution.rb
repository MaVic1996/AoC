def solve_1(file_path)
  File.read(file_path).split("\n").map{|round| point_round_1(round)}.sum
end

def solve_2(file_path)
  File.read(file_path).split("\n").map{|round| point_round_2(round)}.sum
end

def point_round_1(round)
  point_hand ={
    X: 1,
    Y: 2,
    Z: 3
  }
  points = 0
  oponent, you = round.split()
  case oponent
    when 'A'
      points = you == 'X' ? 3 : you == 'Y' ? 6 : 0 
    when 'B'
      points = you == 'X' ? 0 : you == 'Y' ? 3 : 6
    else
      points = you == 'X' ? 6 : you == 'Y' ? 0 : 3
  end
  return points + point_hand[you.to_sym]
end

def point_round_2(round)
  point_hand =  {
    A: 1,
    B: 2,
    C: 3, 
    Z: 6,
    Y: 3,
    X: 0
  }
  oponent, you = round.split()
  hand = nil
  case oponent
  when 'A'
    hand = you == 'X' ? :C : you == 'Y' ? :A : :B
  when 'B'
    hand = you == 'X' ? :A : you == 'Y' ? :B : :C
  else
    hand = you == 'X' ? :B : you == 'Y' ? :C : :A
  end
  return point_hand[you.to_sym] + point_hand[hand]
end
