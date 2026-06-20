import gleam/io
import gleam/list
import gleam/string

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let char_pattern = string.length(pattern) == 1
  case pattern {
    "\\d" -> contains_digit(input_line)
    x if char_pattern -> string.contains(input_line, x)
    _ -> {
      io.println("Unhandled pattern: " <> pattern)
      False
    }
  }
}

pub fn contains_digit(input: String) -> Bool {
  input
  |> string.to_graphemes
  |> list.any(fn(char) { is_digit(char) })
}

pub fn is_digit(char: String) -> Bool {
  case char {
    "0" | "1" | "2" | "3" | "4" | "5" | "6" | "7" | "8" | "9" -> True
    _ -> False
  }
}
