import gleam/io
import gleam/list
import gleam/string

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let char_pattern = string.length(pattern) == 1
  case pattern {
    "\\d" -> contains_digit(input_line)
    "\\w" -> is_word(input_line)
    x if char_pattern -> string.contains(input_line, x)
    _ -> {
      io.println("Unhandled pattern: " <> pattern)
      False
    }
  }
}

fn is_word(input_line: String) -> Bool {
  input_line
  |> string.to_graphemes
  |> list.any(fn(char) { is_digit(char) || is_letter(char) || char == "_" })
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

pub fn is_letter(char: String) -> Bool {
  case string.to_utf_codepoints(char) {
    [codepoint] ->
      codepoint
      |> string.utf_codepoint_to_int
      |> is_ascii_letter
    _ -> False
  }
}

pub fn is_ascii_letter(codepoint: Int) -> Bool {
  { codepoint >= 97 && codepoint <= 122 }
  // a-z
  || { codepoint >= 65 && codepoint <= 90 }
  // A-Z
}
