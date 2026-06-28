import gleam/list
import gleam/string

import pattern_parser.{
  type Pattern, Anchored, Char, Digit, End, Group, NegativeGroup, OneOrMore,
  Optional, Sequence, Start, Word, ZeroOrMore,
}

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  match_parsed_pattern(pattern, input_chars)
}

fn match_parsed_pattern(pattern: Pattern, input_chars: List(String)) -> Bool {
  case pattern {
    Sequence([]) -> False
    Sequence(patterns) -> match_pattern_list(input_chars, patterns)
    Anchored(patterns) ->
      match_sequence(input_chars, list.append(patterns, [End]))
    OneOrMore(p) ->
      list.any(input_chars, fn(char) { match_char_pattern(char, p) })
    ZeroOrMore(_) -> True
    Optional(_) -> True
    Digit -> list.any(input_chars, is_digit)
    Char(c) -> list.contains(input_chars, c)
    NegativeGroup(g) ->
      list.any(input_chars, fn(char) { !list.contains(g, char) })
    Group(g) -> list.any(input_chars, fn(char) { list.contains(g, char) })
    Word -> list.any(input_chars, is_word_char)
    Start -> True
    _ -> False
  }
}

fn match_pattern_list(input: List(String), patterns: List(Pattern)) -> Bool {
  case input, patterns {
    [a, ..bs], [Start, x, ..xs] ->
      match_char_pattern(a, x) && match_pattern_list_loop(bs, xs)
    _, _ -> match_pattern_list_loop(input, patterns)
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
    [], [Optional(_), ..rest_patterns] -> match_sequence([], rest_patterns)
    [], [ZeroOrMore(_), ..rest_patterns] -> match_sequence([], rest_patterns)
    [], _ -> False
    [c, ..rest_input], [OneOrMore(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True ->
          match_sequence(rest_input, rest_patterns)
          || match_sequence(rest_input, [OneOrMore(p), ..rest_patterns])
        False -> False
      }
    }

    [c, ..rest_input], [ZeroOrMore(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True ->
          match_sequence(rest_input, rest_patterns)
          || match_sequence(rest_input, [ZeroOrMore(p), ..rest_patterns])
          || match_sequence(input, rest_patterns)
        False -> match_sequence(input, rest_patterns)
      }
    }

    [c, ..rest_input], [Optional(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True ->
          match_sequence(rest_input, rest_patterns)
          || match_sequence(input, rest_patterns)
        False -> match_sequence(input, rest_patterns)
      }
    }

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
    Group(g) -> list.contains(g, char)
    NegativeGroup(g) -> !list.contains(g, char)
    _ -> False
  }
}

fn is_word_char(char: String) -> Bool {
  is_digit(char) || is_letter(char) || char == "_"
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
  || { codepoint >= 65 && codepoint <= 90 }
}
