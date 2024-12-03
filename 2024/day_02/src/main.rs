use std::fs;
use std::convert::TryInto;

fn main() {
  let file_name = "day_02/input.txt";
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


fn part1(input: &str) -> i32 {
  let valids = input.lines().filter(|&x| validate_line(x)).count();
  return valids.try_into().expect("Error al convertir a entero");
}


fn validate_line(line: &str) -> bool {
  let split: Vec<&str> = line.split_whitespace().collect();
  let valid_diffs: [i32; 6] = [-3, -2, -1, 1, 2, 3];
  let mut direction: Option<bool> = None; // true for increasing, false for decreasing
  for i in 0..split.len()-1 {
    let first = split[i].parse::<i32>().expect("Error al parsear a entero");
    let second = split[i+1].parse::<i32>().expect("Error al parsear a entero");
    if !valid_diffs.contains(&(second - first)) {
      return false;
    } 

    match direction {
      None => direction = Some(first < second),
      Some(val) => if val != (first < second) {
        return false;
      }
    }
  }
  return true;
}

fn part2(input: &str) -> i32 {
  let valids = input.lines().filter(|&line| {
    let splitted_line: Vec<&str> = line.split_whitespace().collect();
    for i in 0..splitted_line.len() {
      let mut removed: Vec<&str> = splitted_line.clone();
      removed.remove(i);
      if validate_line(&removed.join(" ")) {
        return true;
      }
    }
    return false;
  }
  ).count();
  return valids.try_into().expect("Error al convertir a entero");
}