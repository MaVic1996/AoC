

def solve_1(file_path)
  file_data = File.read(file_path).split("\n")
  tree = build_tree(file_data)
  tree.recalculate_weight
  tree.get_weights_at_most(100000).sum
end

def solve_2(file_path)
  file_data = File.read(file_path).split("\n")
  tree = build_tree(file_data)
  tree.recalculate_weight
  tree.get_weights_to_free(30000000, 70000000).min
end


def build_tree(file_data)
  root_node = Node.new(value: '/', root: true)
  tree = Tree.new(root_node)
  current_node = root_node
  idx = 1
  file_data[1..-1].each do |line|
    if line.include?('$ cd ..')
      current_node = tree.get_parent(current_node)
    elsif line.include?('$ cd ')
      current_node = tree.get_children(current_node, line.split('$ cd ')[1])
    elsif line.include?('dir')
      current_node.children << Node.new(value: line.split('dir ')[1], parent: current_node)
    elsif line.include?('$ ls')
      ''
    else
      current_node.children << Node.new(value: line.split(' ')[1], kind: 'file', weight: line.split(' ')[0].to_i, parent: current_node )
    end
    idx += 1
  end
  tree
end



class Node
  
  attr_accessor :value, :children, :root, :kind, :weight, :parent

  def initialize(value: nil, children: [], root: false, kind: 'dir', weight: 0, parent: nil)
    @value = value
    @children = children
    @root = root
    @kind = kind
    @weight = weight
    @parent = parent
  end
end

class Tree 
  attr_reader :root

  def initialize(root)
    @root = root
  end

  def get_children(current_node, value)
    current_node.children.find{|child| child.value == value}
  end

  def get_parent(node)
    node.parent || node
  end

  def recalculate_weight
    recalculate_weight_rec(root)
  end

  def get_weights_at_most(limit)
    get_weights_at_most_rec(root, limit, [])
  end

  def get_weights_to_free(to_free, total_disk)
    weights = get_weights_to_free_rec(root, to_free, total_disk, [])
  end

  def print
    puts print_rec(root, 0)
  end

  private

  
  def recalculate_weight_rec(current_node)
    if current_node.children.empty?
      return current_node.weight
    end
    current_node.weight = current_node.children.map{|child| recalculate_weight_rec(child)}.sum
    current_node.weight
  end

  def get_weights_at_most_rec(current_node, limit, weights)
    if 0 < current_node.weight && current_node.weight <=limit && current_node.kind == 'dir'
      weights << current_node.weight
    end
    current_node.children.each{|child| get_weights_at_most_rec(child, limit, weights)}
    weights
  end

  def get_weights_to_free_rec(current_node, to_free, total_disk, weights)
    to_reach = to_free - (total_disk - root.weight)
    if to_reach <= current_node.weight && current_node.kind == 'dir'
      weights << current_node.weight
    end
    current_node.children.each{|child| get_weights_to_free_rec(child, to_free, total_disk, weights)}
    weights
  end

  def print_rec(current_node, level)
    str = "#{'  '*level} - #{current_node.value} (#{current_node.kind}, size=#{current_node.weight})\n"
    current_node.children.each{|child| str += print_rec(child, level+1)}
    str
  end
end

