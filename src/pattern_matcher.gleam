import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/string

import pattern_parser.{
  type Pattern, Alternative, Anchored, Char, Digit, End, Group, NegativeGroup,
  OneOrMore, Optional, Sequence, Start, Wildcard, Word, ZeroOrMore,
}

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  match_parsed_pattern(pattern, input_chars)
}

pub fn first_match(input_line: String, pattern: String) -> Option(String) {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  case pattern {
    Anchored(patterns) -> {
      case match_sequence(input_chars, list.append(patterns, [End])) {
        Ok(remaining) -> Some(take_prefix(input_chars, remaining))
        Error(Nil) -> None
      }
    }
    Sequence(patterns) ->
      first_match_loop(patterns, input_chars, input_chars, 0)
    _ -> first_match_loop([pattern], input_chars, input_chars, 0)
  }
}

fn take_prefix(input: List(String), remaining: List(String)) -> String {
  let consumed = list.length(input) - list.length(remaining)
  input
  |> list.take(consumed)
  |> string.concat
}

fn first_match_loop(
  patterns: List(Pattern),
  input: List(String),
  original: List(String),
  skipped: Int,
) -> Option(String) {
  case match_pattern_list_once(input, patterns) {
    Ok(remaining) -> {
      let consumed = list.length(input) - list.length(remaining)
      original
      |> list.drop(skipped)
      |> list.take(consumed)
      |> string.concat
      |> Some
    }
    Error(Nil) -> {
      case input {
        [] -> None
        [_, ..rest] -> first_match_loop(patterns, rest, original, skipped + 1)
      }
    }
  }
}

fn match_pattern_list_once(
  input: List(String),
  patterns: List(Pattern),
) -> Result(List(String), Nil) {
  case input, patterns {
    [a, ..bs], [Start, x, ..xs] -> {
      case match_char_pattern(a, x) {
        True -> match_sequence(bs, xs)
        False -> Error(Nil)
      }
    }
    _, _ -> match_sequence(input, patterns)
  }
}

fn match_parsed_pattern(pattern: Pattern, input_chars: List(String)) -> Bool {
  case pattern {
    Wildcard -> list.length(input_chars) == 1
    Sequence([]) -> False
    Sequence(patterns) -> {
      case match_pattern_list(input_chars, patterns) {
        Ok(_) -> True
        Error(Nil) -> False
      }
    }
    Anchored(patterns) -> {
      case match_sequence(input_chars, list.append(patterns, [End])) {
        Ok(_) -> True
        Error(Nil) -> False
      }
    }
    OneOrMore(p) ->
      list.any(input_chars, fn(char) { match_char_pattern(char, p) })
    ZeroOrMore(_) -> True
    Optional(_) -> True
    Digit -> list.any(input_chars, is_digit)
    Char(c) -> list.contains(input_chars, c)
    NegativeGroup(g) ->
      list.any(input_chars, fn(char) { !list.contains(g, char) })
    Group(g) -> list.any(input_chars, fn(char) { list.contains(g, char) })
    Alternative(ps) ->
      list.any(ps, fn(p) { match_parsed_pattern(p, input_chars) })
    Word -> list.any(input_chars, is_word_char)
    Start -> True
    _ -> False
  }
}

fn match_pattern_list(
  input: List(String),
  patterns: List(Pattern),
) -> Result(List(String), Nil) {
  case input, patterns {
    [a, ..bs], [Start, x, ..xs] -> {
      case match_char_pattern(a, x) {
        True -> match_sequence(bs, xs)
        False -> Error(Nil)
      }
    }
    _, _ -> match_pattern_list_loop(input, patterns)
  }
}

fn match_pattern_list_loop(
  input: List(String),
  patterns: List(Pattern),
) -> Result(List(String), Nil) {
  case match_sequence(input, patterns) {
    Ok(remaining) -> Ok(remaining)
    Error(Nil) -> {
      case input {
        [] -> Error(Nil)
        [_, ..rest] -> match_pattern_list_loop(rest, patterns)
      }
    }
  }
}

fn match_sequence(
  input: List(String),
  patterns: List(Pattern),
) -> Result(List(String), Nil) {
  case input, patterns {
    _, [] -> Ok(input)
    [], [End] -> Ok([])
    [], [Optional(_), ..rest_patterns] -> match_sequence([], rest_patterns)
    [], [ZeroOrMore(_), ..rest_patterns] -> match_sequence([], rest_patterns)
    [], _ -> Error(Nil)
    [c, ..rest_input], [OneOrMore(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> {
          case match_sequence(rest_input, rest_patterns) {
            Ok(remaining) -> Ok(remaining)
            Error(Nil) ->
              match_sequence(rest_input, [OneOrMore(p), ..rest_patterns])
          }
        }
        False -> Error(Nil)
      }
    }
    [c, ..rest_input], [ZeroOrMore(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> {
          case match_sequence(rest_input, rest_patterns) {
            Ok(remaining) -> Ok(remaining)
            Error(Nil) -> {
              case
                match_sequence(rest_input, [ZeroOrMore(p), ..rest_patterns])
              {
                Ok(remaining) -> Ok(remaining)
                Error(Nil) -> match_sequence(input, rest_patterns)
              }
            }
          }
        }
        False -> match_sequence(input, rest_patterns)
      }
    }
    [c, ..rest_input], [Optional(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> {
          case match_sequence(rest_input, rest_patterns) {
            Ok(remaining) -> Ok(remaining)
            Error(Nil) -> match_sequence(input, rest_patterns)
          }
        }
        False -> match_sequence(input, rest_patterns)
      }
    }
    x, [Alternative(p), ..rest_patterns] -> {
      try_alternatives(p, x, rest_patterns)
    }
    [c, ..rest_input], [p, ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> match_sequence(rest_input, rest_patterns)
        False -> Error(Nil)
      }
    }
  }
}

fn try_alternatives(
  alternatives: List(Pattern),
  input: List(String),
  rest_patterns: List(Pattern),
) -> Result(List(String), Nil) {
  case alternatives {
    [] -> Error(Nil)
    [first, ..rest] -> {
      let result = case first {
        Sequence(branch_patterns) ->
          match_sequence(input, list.append(branch_patterns, rest_patterns))
        _ -> match_sequence(input, [first, ..rest_patterns])
      }
      case result {
        Ok(remaining) -> Ok(remaining)
        Error(Nil) -> try_alternatives(rest, input, rest_patterns)
      }
    }
  }
}

fn match_char_pattern(char: String, pattern: Pattern) -> Bool {
  case pattern {
    Digit -> is_digit(char)
    Wildcard -> True
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
