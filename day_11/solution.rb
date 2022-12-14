

def solve_1(file_path = 'day_11/example.txt')
  monkey_list = File.read(file_path).gsub("\r",'').split("\n\n").map{|data| parse_monkey_data(data)}
  lam_f = lambda {|wr| wr/3 }
  max_1, max_2 = pass_rounds(monkey_list, 20, lam_f).values.max(2)
  max_1 * max_2
end

def solve_2(file_path = 'day_11/example.txt')
  monkey_list = File.read(file_path).gsub("\r",'').split("\n\n").map{|data| parse_monkey_data(data)}
  lam_f = lambda {|wr| wr % monkey_list.map(&:condition).reduce{|a,b| lcm(a,b)} }
  max_1, max_2 = pass_rounds(monkey_list, 10000, lam_f).values.max(2)
  max_1 * max_2
end

def pass_rounds(monkey_list, rounds, worry_level)
  inspect_map = monkey_list.map{|m| [m.id, 0]}.to_h
  rounds.times do |round|
    monkey_list.each do |monkey|
      inspect_map[monkey.id] = inspect_map[monkey.id] + monkey.items.count
      monkey.inspect_items(worry_level).map do |next_monkey, item|
        monkey_list.select{|m| m.id == next_monkey}.first.items << item
      end
    end
  end
  inspect_map
end

def parse_monkey_data(data)
  id, items, operation, condition, id_true, id_false = data.split("\n")
  
  Monkey.new(id, items, operation, condition, id_true, id_false)
end



class Monkey

  attr_accessor :id, :items, :worry_operation, :condition, :id_true, :id_false
  
  def initialize(id, items, worry_operation, condition, id_true, id_false)
    @id = parse_id(id)
    @items = items.match(/\d+(, \d+)*/).to_a[0].split(',').map(&:to_i)
    @worry_operation = parse_worry_operation(worry_operation) 
    @condition = check_condition(condition.match(/\d+/).to_s.to_i)
    @id_true = parse_id(id_true)
    @id_false = parse_id(id_false)
  end

  def parse_id(unparsed)
    unparsed.match(/\d+/).to_a[0].to_i
  end

  def parse_worry_operation(worry_operation)
    worry_operation.split("new = ")[1]
  end

  def check_condition(condition)
    condition
  end

  def inspect_items(wl_calc)
    monkey_item = []
    items.each do |item|
      old = item
      new_worry_level = eval(worry_operation)
      new_worry_level = wl_calc.call(new_worry_level)
      if new_worry_level % condition == 0
        monkey_item << [id_true, new_worry_level]
      else
        monkey_item << [id_false, new_worry_level]
      end
    end
    @items = []
    monkey_item
  end


end
