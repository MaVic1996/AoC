use std::fs;

fn main() {
  let file_name = "day_07/input.txt";
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
  let mut correct_results: Vec<i64> = Vec::new();
  for line in input.lines() {
    let splitted = line.split(":").collect::<Vec<&str>>();

    let result = splitted[0].parse::<i64>().expect("Error al convertir a entero");
    let numbers = splitted[1].trim().split(" ").map(|x| x.parse::<i64>().expect("Error al convertir a entero")).collect::<Vec<i64>>();

    if check_result(result, &numbers) {
      correct_results.push(result);
    }
  }
  return correct_results.into_iter().sum::<i64>() as i64;
}

fn part2(input: &str) -> i64 {
  let mut correct_results: Vec<i64> = Vec::new();
  for line in input.lines() {
    let splitted = line.split(":").collect::<Vec<&str>>();

    let result = splitted[0].parse::<i64>().expect("Error al convertir a entero");
    let numbers = splitted[1].trim().split(" ").map(|x| x.parse::<i64>().expect("Error al convertir a entero")).collect::<Vec<i64>>();

    if check_results_concatenate(result, &numbers) {
      correct_results.push(result);
    }
  }
  return correct_results.into_iter().sum::<i64>() as i64;
}

fn check_result(result: i64, numbers: &[i64]) -> bool {
  if numbers.len() == 1 {
    if numbers[0] == result {
      return true;
    } else  {
      return false;
    }
  }


  let last = numbers[numbers.len()-1];
  let rest = &numbers[..numbers.len()-1];

  // Recurre para comprobar si alguna combinación de + o * con el resto da el objetivo.
  let rest_combinations = check_result(result - last, rest) // Suma
      || (result % last == 0 && check_result(result / last, rest));  // Multiplicación

  return rest_combinations;
}


fn check_results_concatenate(result: i64, numbers: &[i64]) -> bool {
  if numbers.len() == 2 {
    // println!("Only 2 numbers");
    // println!("Numbers: {} {} - Result: {}", numbers[0], numbers[1], result);
    // println!("Multiplication: {} - Sum: {} - Concatenate: {}", numbers[0] * numbers[1], numbers[0] + numbers[1], format!("{}{}", numbers[0], numbers[1]).parse::<i64>().expect("Error al convertir a entero"));
    // println!("\tResult: {:}", result);
    return numbers[0] * numbers[1] == result || numbers[0] + numbers[1] == result || format!("{}{}",numbers[0], numbers[1]).parse::<i64>().expect("Error al convertir a entero") == result;
  }

  let first = numbers[0];
  let second = numbers[1];
  let rest = &numbers[2..];

  // println!("Numbers: {} {} {:?} - Result: {}", first, second, rest, result);
  // println!("Multiplication: {} - Sum: {} - Concatenate: {}", first * second, first + second, format!("{}{}", first, second).parse::<i64>().expect("Error al convertir a entero"));
  // println!("\tRest: {:?}", rest);
  // Recurre para comprobar si alguna combinación de + o * con el resto da el objetivo.
  let rest_combinations = check_results_concatenate(result, &prepend_list(rest, first + second)) // Suma
      || check_results_concatenate(result, &prepend_list(rest, first * second))  // Multiplicación;
      || check_results_concatenate(result, &prepend_list(rest, format!("{}{}", first, second).parse::<i64>().expect("Error al convertir a entero")));

  return rest_combinations;
}

fn prepend_list(list: &[i64], element: i64) -> Vec<i64> {
  let mut new_list = Vec::new();
  new_list.push(element);
  new_list.extend_from_slice(list);
  return new_list;
}