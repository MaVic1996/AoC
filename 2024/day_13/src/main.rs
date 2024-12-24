use std::fs;
use regex::Regex;


fn main() {
  let file_name = "day_13/input.txt";
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

#[derive(Clone)]
struct Problem {
  pub res_x: i64,
  pub res_y: i64,
  a_x: i64,
  a_y: i64,
  b_x: i64,
  b_y: i64,
}


fn part1(input: &str) -> i64 {
  let inputs = input.split("\n\n").collect::<Vec<&str>>();
  let problems = inputs.into_iter().map(|x| parse_problem(x)).collect::<Vec<Problem>>();
  let mut token_sum = 0;
  for problem in problems {
    let solved_problem = solve_problem(problem, 100);
    if solved_problem.0 > 0 || solved_problem.1 > 0 {
      token_sum += solved_problem.0*3 + solved_problem.1;
    }
  }

  return token_sum;
}

fn part2(input: &str) -> i64 {
  let inputs = input.split("\n\n").collect::<Vec<&str>>();
  let problems = inputs.into_iter().map(|x| parse_problem(x)).collect::<Vec<Problem>>();
  let mut token_sum = 0;
  for problem in problems {
    let mut problem_copy = problem.clone();
    problem_copy.res_x = 10000000000000 + problem.res_x;
    problem_copy.res_y = 10000000000000 + problem.res_y;
    let solved_problem = solve_crammer(problem_copy);
    if solved_problem.0 > 0 || solved_problem.1 > 0 {
      token_sum += solved_problem.0*3 + solved_problem.1;
    }
  }

  return token_sum;
}


fn parse_problem(problem: &str) -> Problem {
  let mut lines = problem.lines();

  let a = extract_numbers(lines.next().unwrap());
  let b = extract_numbers(lines.next().unwrap());
  let res = extract_numbers(lines.next().unwrap());

  return Problem {
    res_x: res[0],
    res_y: res[1],
    a_x: a[0],
    a_y: a[1],
    b_x: b[0],
    b_y: b[1],
  };
}

fn extract_numbers(line: &str) -> Vec<i64> {
  let re = Regex::new(r"[-]?\d+").unwrap();
  re.find_iter(line)
    .map(|digits| digits.as_str().parse::<i64>().unwrap())
    .collect()
}

fn solve_problem(problem: Problem, max_sec_tries: i64) -> (i64, i64) {

 for a in 0..max_sec_tries {
   for b in 0..max_sec_tries {
     if problem.a_x * a + problem.b_x * b == problem.res_x && problem.a_y * a + problem.b_y * b == problem.res_y {
       return (a, b);
     }
   }
 }

 return (-1, -1)
}

fn solve_crammer(problem: Problem) -> (i64, i64) {
  let det_a = problem.a_x * problem.b_y - problem.a_y * problem.b_x;

  let det_a_a = problem.res_x * problem.b_y - problem.res_y * problem.b_x;
  let det_a_b = problem.a_x * problem.res_y - problem.a_y * problem.res_x;

  if det_a != 0 {
    let a = det_a_a / det_a;
    let b = det_a_b / det_a;
    if det_a_a % det_a == 0 && det_a_b % det_a == 0 {
      return (a, b);
    }
    return (-1, -1);
  }

  return (-1, -1);
}