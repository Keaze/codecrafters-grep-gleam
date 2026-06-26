import gleam/list
import gleam/string

import pattern_parser.{
  type Pattern, Char, Digit, End, Group, NGroup, PatternList, Start, Word,
}

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  case pattern {
    PatternList([]) -> False
    PatternList(patterns) -> match_pattern_list(input_line, patterns)
    Digit -> contains_digit(input_line)
    Char(c) -> string.contains(input_line, c)
    NGroup(g) -> match_negative_group(input_line, g)
    Group(g) -> match_group(input_line, g)
    Word -> is_word(input_line)
    _ -> False
  }
}

fn match_pattern_list(input_line: String, patterns: List(Pattern)) -> Bool {
  let input_chars = string.to_graphemes(input_line)
  case input_chars, patterns {
    [a, ..bs], [Start, x, ..xs] ->
      match_char_pattern(a, x) && match_pattern_list_loop(bs, xs)
    _, _ -> match_pattern_list_loop(input_chars, patterns)
  }
}

fn match_pattern_list_loop(
  input: List(String),
  patterns: List(Pattern),
) -> Bool {
  case match_sequence(input, patterns) {
    True -> True
    False -> {
      case input {
        [] -> False
        [_, ..rest] -> match_pattern_list_loop(rest, patterns)
      }
    }
  }
}

fn match_sequence(input: List(String), patterns: List(Pattern)) -> Bool {
  case input, patterns {
    _, [] -> True
    [], [End] -> True
    [], _ -> False
    [c, ..rest_input], [p, ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> match_sequence(rest_input, rest_patterns)
        False -> False
      }
    }
  }
}

fn match_char_pattern(char: String, pattern: Pattern) -> Bool {
  case pattern {
    Digit -> is_digit(char)
    Word -> is_word_char(char)
    Char(c) -> char == c
    Group(g) -> list.contains(string.to_graphemes(g), char)
    NGroup(g) -> !list.contains(string.to_graphemes(g), char)
    _ -> False
  }
}

fn is_word_char(char: String) -> Bool {
  is_digit(char) || is_letter(char) || char == "_"
}

fn match_negative_group(input_line: String, pattern: String) -> Bool {
  let graphemes = string.to_graphemes(pattern)

  input_line
  |> string.to_graphemes
  |> list.any(fn(char) { !list.contains(graphemes, char) })
}

fn match_group(input_line: String, pattern: String) -> Bool {
  string.to_graphemes(pattern)
  |> list.any(fn(char) { string.contains(input_line, char) })
}

fn is_word(input_line: String) -> Bool {
  input_line
  |> string.to_graphemes
  |> list.any(is_word_char)
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
