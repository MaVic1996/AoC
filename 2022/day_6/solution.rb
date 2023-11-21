

def solve_1(file_path)
  File.read(file_path).split("\n").map{|x| process(x, 4)}
end

def solve_2(file_path)
  File.read(file_path).split("\n").map{|x| process(x, 14)}
end


def process(chain, chars_num)
  chain_charts = chain.chars
  processed = 0
  current_chain = []
  while processed < chain_charts.length && current_chain.length < chars_num
    if current_chain.include?(chain_charts[processed])
      idx = current_chain.index(chain_charts[processed]) + 1
      current_chain = current_chain[idx..-1]
      processed = processed - (idx)
    else 
      current_chain << chain_charts[processed]
    end
    processed += 1
  end
  return processed
end