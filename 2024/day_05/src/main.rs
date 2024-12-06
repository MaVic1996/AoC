use std::fs;
use std::collections::HashMap;

fn main() {
  let file_name = "day_05/input.txt";
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

fn part1(input: &str) -> i32{
  let rules:Vec<(i32,i32)> = load_rules(input);

  let mut correct_pages  = Vec::new();

  for line in input.lines() {
    if line.contains("|") || line == "" {
      continue;
    }
    if check_page(&rules, line) {
      correct_pages.push(line);
    }
  }
  // get the number in the middle of the page
  return correct_pages.iter().map(|x| {
    let splitted_line: Vec<&str> = x.split(",").collect();
    let middle = splitted_line.len()/2;
    let middle = splitted_line[middle].parse::<i32>().expect("Error al convertir a entero");
    return middle;
  }).sum();
}

fn part2(input: &str) -> i32 {
  let rules:Vec<(i32,i32)> = load_rules(input);
  
  let mut incorrect_pages  = Vec::new();

  for line in input.lines() {
    if line.contains("|") || line == "" {
      continue;
    }
    if !check_page(&rules, line) {
      incorrect_pages.push(line);
    }
  }
  let mut corrected_pages = Vec::new();
  for page in &incorrect_pages {
    corrected_pages.push(fix_page(&rules, page));
  }

  return corrected_pages.iter().map(|splitted_line| {
    let middle = splitted_line.len()/2;
    let middle = splitted_line[middle].parse::<i32>().expect("Error al convertir a entero");
    return middle;
  }).sum();
}

fn load_rules(input: &str) -> Vec<(i32,i32)> {
  let mut rules:Vec<(i32,i32)> = Vec::new();
  for line in input.lines() {
    if line == "" {
      break;
    }
    let split: Vec<i32> = line.split("|").map(|x| x.parse::<i32>().expect("No se pudo convertir a número")).collect();
    let rule = (split[0], split[1]);
    rules.push(rule);
  }
  return rules;
}

fn check_page(rules:&Vec<(i32,i32)>, line:&str) -> bool {
  let splitted_line: Vec<&str> = line.split(",").collect();
  let mut valid = true;
  for i in 0..splitted_line.len() {
    let left: i32 = splitted_line[i].parse::<i32>().expect("Error al convertir a entero");
    for j in i..splitted_line.len() {
      let right: i32 = splitted_line[j].parse::<i32>().expect("Error al convertir a entero");
      for &(first, second) in rules{
        if second == left && first == right {
          valid = false;
          break;
        }  
      }
    }
  }
  return valid;
}


fn fix_page<'a>(rules:&'a Vec<(i32,i32)>, pages:&'a str) -> Vec<&'a str> {
  let mut splitted_line: Vec<&str> = pages.split(",").collect();
  // get the rules that match with de pages
  let related_rules = rules.iter().filter(|(x,y)| {
    splitted_line.contains(&x.to_string().as_str()) && splitted_line.contains(&y.to_string().as_str())
  }).collect::<Vec<&(i32,i32)>>();

  let mut freq_x: HashMap<String, usize> = HashMap::new();

  for (x,_) in &related_rules {
    *freq_x.entry(x.to_string()).or_insert(0)+=1;
  }
  splitted_line.sort_by_key(|&num| (usize::MAX - freq_x.get(&num.to_string()).unwrap_or(&0), num));

  return splitted_line;
}
