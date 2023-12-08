CARD_POINTS = {
  'A': 13,
  'K': 12,
  'Q': 11,
  'J': 10,
  'T': 9,
  '9': 8,
  '8': 7,
  '7': 6,
  '6': 5,
  '5': 4,
  '4': 3,
  '3': 2,
  '2': 1
}

def solve_first(input)
  parsed = input.map{|line| line.split(' ')}.to_h
  sorted = parsed.sort do |card_a, card_b|
    sorted_value = 0
    a_points = calculate_point_card(card_a)
    b_points = calculate_point_card(card_b)
    if a_points == b_points
      card_a[0].split('').each_with_index do |char, idx|
        next if CARD_POINTS[char.to_sym] == CARD_POINTS[card_b[0][idx].to_sym]

        sorted_value = CARD_POINTS[char.to_sym] - CARD_POINTS[card_b[0][idx].to_sym]
        break
      end
    else
      sorted_value = a_points - b_points
    end
    sorted_value
  end
  sorted.map{|_,v|v.to_i}.each_with_index.map{|val, idx| val.to_i * (idx+1)}.sum
end

def solve_second(input)
  parsed = input.map{|line| line.split(' ')}.to_h
  sorted = parsed.sort do |card_a, card_b|
    sorted_value = 0
    a_points = calculate_point_card(card_a, true)
    b_points = calculate_point_card(card_b, true)
    if a_points == b_points
      card_a[0].split('').each_with_index do |char, idx|
        next if CARD_POINTS[char.to_sym] == CARD_POINTS[card_b[0][idx].to_sym]

        sorted_value = CARD_POINTS[char.to_sym] - CARD_POINTS[card_b[0][idx].to_sym]
        break
      end
    else
      sorted_value = a_points - b_points
    end
    sorted_value
  end
  p sorted
  sorted.map{|_,v|v.to_i}.each_with_index.map{|val, idx| val.to_i * (idx+1)}.sum
end

def calculate_point_card(card, jokers=false)
  card_count = card[0].split('').reduce({}) do |acc, char|
    acc[char] = 0 if acc[char].nil?
    acc[char] = acc[char] + 1
    acc
  end
  if jokers
    CARD_POINTS[:J] = 0
    max = get_max_card(card_count)
    if card_count['J'] != 5
        card_count[max] += card_count['J'].to_i 
        card_count['J'] = 0
    end
  end
  return 12 if card_count.values.count(5) > 0
  return 10 if card_count.values.count(4) > 0
  return 8 if card_count.values.count(3) > 0 && card_count.values.count(2) > 0
  return 6 if card_count.values.count(3) > 0
  return 4 if card_count.values.count(2) > 1
  return 2 if card_count.values.count(2) > 0
  0
end

def get_max_card(card_count)
  card_count.reduce(nil) do |acc, (key, val)|
    if acc.nil?
      acc = key unless key.to_s == 'J'
    elsif card_count[acc] < val && key.to_s != 'J'
      acc = key 
    elsif card_count[acc] == val
      acc = key if CARD_POINTS[key.to_sym] > CARD_POINTS[acc.to_sym] && key.to_s != 'J'
    end
    acc
  end
end

def solve_both(file_path = './input.txt')
  file = File.read(file_path).split("\n")

  puts "Part 1: #{solve_first(file)}"
  puts "Part 2: #{solve_second(file)}"
end

solve_both(*ARGV)
