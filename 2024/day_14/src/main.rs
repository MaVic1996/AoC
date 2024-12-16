use std::fs;
use std::collections::HashMap;
use image::{ImageBuffer, Luma};

struct Robot {
  pub position: (i64, i64),
  pub direction: (i64, i64),
  map_width: i64,
  map_height: i64
}

impl Robot {
  fn new(position: (i64, i64), direction: (i64, i64), map_width: i64, map_height: i64) -> Robot {
    Robot { position, direction, map_width, map_height }
  }

  fn walk(&mut self) {
    let mut new_position = (self.position.0 + self.direction.0, self.position.1 + self.direction.1);
    if new_position.0 < 0 {
      new_position.0 = self.map_width + new_position.0;
    } else if new_position.0 >= self.map_width {
      new_position.0 = new_position.0 - self.map_width;
    }

    if new_position.1 < 0 {
      new_position.1 = self.map_height + new_position.1;
    } else if new_position.1 >= self.map_height {
      new_position.1 = new_position.1 - self.map_height;
    }
   
    self.position = new_position;
  }
} 


fn main() {
  let file_name = "day_14/input.txt";
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

fn part1(input: &str) -> i64 {
  let map_width = 101;
  let map_height = 103;
  let seconds = 100;
  let mut robot_final_pos: HashMap<(i64, i64), i64> = HashMap::new();

  let mut robots: Vec<Robot> = Vec::new();
  for line in input.lines() {
    let parts: Vec<&str> = line.split_whitespace().collect();
    let position: (i64, i64) = {
      let pos_parts: Vec<i64> = parts[0][2..].split(',').map(|x| x.parse().unwrap()).collect();
      (pos_parts[0], pos_parts[1])
    };
    let direction: (i64, i64) = {
      let dir_parts: Vec<i64> = parts[1][2..].split(',').map(|x| x.parse().unwrap()).collect();
      (dir_parts[0], dir_parts[1])
    };

    robots.push(Robot::new(position, direction, map_width, map_height));
  }

  for robot in robots.iter_mut() {
    for _i in 1..seconds+1 {
      robot.walk();
    }
    
    robot_final_pos.entry(robot.position).and_modify(|value|*value+=1).or_insert(1);
  }

  let mut quadrants: [i64; 4] = [0, 0, 0, 0];
  for (key, value) in robot_final_pos.iter() {
    if key.0 < map_width/2 {
      if key.1 < map_height/2 {
        quadrants[0]+=value;
      }
      if key.1 > map_height/2 {
        quadrants[2]+=value;
      }
    } 
    if key.0 > map_width/2 {
      if key.1 < map_height/2 {
        quadrants[1]+=value;
      } 
      if key.1 > map_height/2  {
        quadrants[3]+=value;
      }
    }
  }
  return quadrants.iter().fold(1, |acc, &x| acc * x) as i64;
}

fn part2(input: &str) -> i64 {
  let map_width = 101;
  let map_height = 103;
  let seconds = 10_000;

  let mut robots: Vec<Robot> = Vec::new();
  for line in input.lines() {
    let parts: Vec<&str> = line.split_whitespace().collect();
    let position: (i64, i64) = {
      let pos_parts: Vec<i64> = parts[0][2..].split(',').map(|x| x.parse().unwrap()).collect();
      (pos_parts[0], pos_parts[1])
    };
    let direction: (i64, i64) = {
      let dir_parts: Vec<i64> = parts[1][2..].split(',').map(|x| x.parse().unwrap()).collect();
      (dir_parts[0], dir_parts[1])
    };

    robots.push(Robot::new(position, direction, map_width, map_height));
  }

  for i in 1..seconds+1 {
    // create a matrix with the mapheight and width
    let mut robots_draw: Vec<Vec<char>> =  vec![vec![' '; map_width as usize]; map_height as usize];
    for robot in robots.iter_mut() {
      robot.walk();
    }
    draw_map(&robots, &mut robots_draw, i);
  }
  return robots.len() as i64;
}

fn draw_map(robots: &Vec<Robot>, robots_draw: &mut Vec<Vec<char>>, second: i64) {
  let height = robots_draw.len() as u32;
  let width = if height > 0 { robots_draw[0].len() as u32 } else { 0 };

  // Crea un buffer de imagen en escala de grises (Luma<u8>)
  let mut img = ImageBuffer::new(width, height);

  for (y, row) in robots_draw.iter().enumerate() {
      for (x, _) in row.iter().enumerate() {
          let mut color = 255u8; // Blanco
          if robots.iter().any(|robot| robot.position == (x as i64, y as i64)) {
              color = 0u8; // 
          }
          img.put_pixel(x as u32, y as u32, Luma([color]));
      }
  }

  // Guarda la imagen como PNG
  let output_file = format!("day_14/outputs/second_{:0>7}.png", second);
  img.save(output_file).expect("No se pudo guardar el archivo PNG");
}
