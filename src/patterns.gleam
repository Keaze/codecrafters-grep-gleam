import gleam/int
import gleam/io
import gleam/list
import gleam/string

type Pattern {
  Digit
  Word
  Group(String)
  NGroup(String)
  Char(String)
  //List(Pattern)
  Invalid
}

fn parse_pattern(pattern) -> Pattern {
  let is_char_pattern = string.length(pattern) == 1
  let is_negative_group_pattern: Bool =
    string.starts_with(pattern, "[^") && string.ends_with(pattern, "]")
  let is_group_pattern: Bool =
    !is_negative_group_pattern
    && string.starts_with(pattern, "[")
    && string.ends_with(pattern, "]")

  case pattern {
    "\\d" -> Digit
    x if is_char_pattern -> Char(x)
    x if is_negative_group_pattern -> NGroup(x)
    x if is_group_pattern -> Group(x)
    "\\w" -> Word
    _ -> {
      io.println("Unhandled pattern: " <> pattern)
      Invalid
    }
  }
}

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let pattern = parse_pattern(pattern)
  case pattern {
    Digit -> contains_digit(input_line)
    Char(c) -> string.contains(input_line, c)
    NGroup(g) -> match_negative_group(input_line, g)
    Group(g) -> match_group(input_line, g)
    Word -> is_word(input_line)
    _ -> {
      io.println("Unhandled pattern: " <> string.inspect(pattern))
      False
    }
  }
}

fn match_negative_group(input_line: String, pattern: String) -> Bool {
  let graphemes = string.to_graphemes(pattern)
  let len = list.length(graphemes)
  let set_chars =
    graphemes
    |> list.drop(2)
    |> list.take(int.max(len - 3, 0))

  input_line
  |> string.to_graphemes
  |> list.any(fn(char) { !list.contains(set_chars, char) })
}

fn match_group(input_line: String, pattern: String) -> Bool {
  let graphemes = string.to_graphemes(pattern)
  let len = list.length(graphemes)
  graphemes
  |> list.drop(1)
  |> list.take(int.max(len - 2, 0))
  |> list.any(fn(char) { string.contains(input_line, char) })
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
