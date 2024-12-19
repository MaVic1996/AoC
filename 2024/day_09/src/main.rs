use std::fs;

fn main() {
  let file_name = "day_09/input.txt";
  let input = read_file(&file_name);
  
  let sol1 = part1(&input);
  println!("Solution for part 1: {}", sol1);

  let sol2 = part2(&input);
  println!("Solution for part 2: {}", sol2);
}


fn read_file(file_name: &str) -> String {
  let file_content = fs::read_to_string(file_name)
    .expect("Something went wrong reading the file");
  
  return file_content;
}

fn part1(input: &str) -> i64{
  let line = input.lines().collect::<Vec<&str>>()[0];
  
  let processed_input = process_input(line.chars().collect::<Vec<char>>());
  let compressed_input = compress(processed_input.clone());

  return calculate_checksum(compressed_input.clone());
}

#[derive(Clone)]
struct Memory {
  pub value: i64,
  pub size: i64,
}

fn part2(input: &str) -> i64 {
  let mut memory_uncompressed: Vec<Memory> = Vec::new();

  for i in 0..input.len() {
    if i%2==0 {
      memory_uncompressed.push(Memory{value: i as i64/2 , size: input.chars().nth(i).unwrap().to_string().parse::<i64>().unwrap()});
    } else {
      memory_uncompressed.push(Memory{value: -1, size: input.chars().nth(i).unwrap().to_string().parse::<i64>().unwrap()});
    }
  }

  let mut idx = memory_uncompressed.len() -1;


  while idx > 0 {
    let mem_to_allocate = memory_uncompressed[idx].clone();
    if mem_to_allocate.value != -1 {
      let idx_to_allocate = find_next_blank(&memory_uncompressed, mem_to_allocate.size, idx);
      if idx_to_allocate == -1 {
        idx-=1;
        continue;
      }
      if memory_uncompressed[idx_to_allocate as usize].size > mem_to_allocate.size {
        let blank_size = memory_uncompressed[idx_to_allocate as usize].size - mem_to_allocate.size;
        memory_uncompressed[idx_to_allocate as usize].value = mem_to_allocate.value;
        memory_uncompressed[idx_to_allocate as usize].size = mem_to_allocate.size;
        memory_uncompressed.insert(idx_to_allocate as usize + 1, Memory{value: -1, size: blank_size});
        memory_uncompressed[idx+1].value = -1;
      } else if memory_uncompressed[idx_to_allocate as usize].size == mem_to_allocate.size {
        memory_uncompressed[idx_to_allocate as usize].value = mem_to_allocate.value;
        memory_uncompressed[idx_to_allocate as usize].size = mem_to_allocate.size;
        memory_uncompressed[idx].value = -1;
      }
    }
    idx -= 1;
  }

  let mut iter = 0;
  let mut checksum = 0;
  for i in 0..memory_uncompressed.len() {
    for _ in 0..memory_uncompressed[i].size {
      if memory_uncompressed[i].value != -1 {
        checksum += memory_uncompressed[i].value * iter as i64;
      }
      iter += 1;
    }
  }

  // return calculate_checksum(in.clone());
  return checksum as i64;
}


fn find_next_blank(memory: &Vec<Memory>, size_to_alloc: i64, limit_idx: usize) -> i64 {
  let mut idx: usize = 0;

  while memory[idx].value != -1 || memory[idx].size < size_to_alloc {
    idx += 1;
    if idx >= memory.len() || idx >= limit_idx {
      return -1;
    }
  }

  return idx as i64;
}


fn process_input(input: Vec<char>)-> Vec<i64> {
  let mut processed_input = Vec::new();
  let mut idx = 0;
  let mut id = 0;

  while idx < input.len() {
    let file_length = input[idx].to_string().parse::<i64>().unwrap();

    for _ in 0..file_length {
      processed_input.push(id);
    }

    idx += 1;
    id += 1;

    if idx >= input.len() {
      break;
    }

    let blank_length = input[idx].to_string().parse::<i64>().unwrap();
    for _ in 0..blank_length {
      processed_input.push(-1);
    }

    idx += 1;

  }

  return processed_input;
}

fn compress(processed_input: Vec<i64>) -> Vec<i64> {
  let mut compressed_input = processed_input.clone();
  let mut left_idx = 0;
  let mut right_idx = compressed_input.len() - 1;

  while left_idx < right_idx {

    while compressed_input[left_idx]!=-1 {
      left_idx += 1;
    }

    while compressed_input[right_idx]== -1 {
      right_idx -= 1;
    }
    if left_idx >= right_idx {
      break;
    }

    compressed_input[left_idx] = compressed_input[right_idx];
    compressed_input[right_idx] = -1;
  }


  return compressed_input;
}

fn calculate_checksum(compressed_input: Vec<i64>) -> i64 {
  let mut checksum = 0;
  for i in 0..compressed_input.len() {
    if compressed_input[i] == -1 {
      break;
    }
    checksum += i as i64 * compressed_input[i];
  }

  return checksum;
}