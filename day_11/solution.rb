

def solve_1(file_path = 'day_11/example.txt')
  monkey_list = File.read(file_path).gsub("\r",'').split("\n\n").map{|data| parse_monkey_data(data)}
  monkey_list
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
    worry_operation
  end

  def check_condition(condition)
    condition
  end


end
