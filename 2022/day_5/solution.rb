
def solve_1(file_path)
  state, instructions = load_initial_data(file_path)
  instructions.each do |instruction|
    instruction[0].times do
      state[instruction[2]] << state[instruction[1]].pop
    end
  end
  state.values.map{|x| x[-1]}.join('')
end

def solve_2(file_path)
  state, instructions = load_initial_data(file_path)
  instructions.each do |instruction|
    partial = to_take(state[instruction[1]], instruction[0])
    maintain = to_maintain(state[instruction[1]], instruction[0])
    state[instruction[1]] = maintain
    state[instruction[2]] += partial
  end
  state.values.map{|x| x[-1]}.join('')
end

def to_take(arr, quantity)
  quantity > arr.length ? arr : arr[-quantity..-1]
end

def to_maintain(arr, quantity)
  quantity > arr.length ? arr : arr[0...-quantity]
end


def load_initial_data(file_path)
  unparsed_state, unparsed_instructions = File.read(file_path).split("\n\n")
  [parse_state(unparsed_state), parse_instructions(unparsed_instructions)]
end


def parse_state(unparsed)
  stacks = unparsed.split("\n").last.split.map{|x| [x.to_i, []]}.to_h
  creaters = unparsed.split("\n")[0..stacks.size-1].reverse.map do |line|
    line.chars.each_slice(4).to_a.map{|elem| elem.filter{ |e| e.match(/[A-Z]/)}}
  end
  creaters.each do |group|
    stacks.keys.each do |key|
      stacks[key] << group[key.to_i - 1] unless group[key.to_i - 1].empty?
    end
  end
  stacks
end

def parse_instructions(unparsed)
  unparsed.split("\n").map do |line|
    line.scan(/\d+/).map(&:to_i)
  end
end