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

pub fn all_matches(input_line: String, pattern: String) -> List(String) {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  case pattern {
    Anchored(patterns) ->
      all_matches_from_start(input_chars, list.append(patterns, [End]))
    Sequence(patterns) -> {
      case patterns {
        [Start, ..] -> all_matches_from_start(input_chars, patterns)
        _ -> all_matches_loop(patterns, input_chars)
      }
    }
    _ -> all_matches_loop([pattern], input_chars)
  }
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

pub fn first_match_position(
  input_line: String,
  pattern: String,
) -> Option(#(Int, String)) {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  case pattern {
    Anchored(patterns) -> {
      case match_sequence(input_chars, list.append(patterns, [End])) {
        Ok(remaining) -> {
          let consumed = list.length(input_chars) - list.length(remaining)
          case consumed > 0 {
            True -> Some(#(0, take_chars(input_chars, consumed)))
            False -> None
          }
        }
        Error(Nil) -> None
      }
    }
    Sequence(patterns) ->
      first_match_position_loop(patterns, input_chars, input_chars, 0)
    _ -> first_match_position_loop([pattern], input_chars, input_chars, 0)
  }
}

pub fn all_match_positions(
  input_line: String,
  pattern: String,
) -> List(#(Int, String)) {
  let pattern = pattern_parser.parse_combined_pattern(pattern)
  let input_chars = string.to_graphemes(input_line)
  case pattern {
    Anchored(patterns) ->
      case match_sequence(input_chars, list.append(patterns, [End])) {
        Ok(remaining) -> {
          let consumed = list.length(input_chars) - list.length(remaining)
          case consumed > 0 {
            True -> [#(0, take_prefix(input_chars, remaining))]
            False -> []
          }
        }
        Error(Nil) -> []
      }
    Sequence(patterns) -> {
      case patterns {
        [Start, ..] -> all_match_positions_from_start(input_chars, patterns)
        _ -> all_match_positions_loop(patterns, input_chars, input_chars, 0, [])
      }
    }
    _ -> all_match_positions_loop([pattern], input_chars, input_chars, 0, [])
  }
}

fn all_match_positions_from_start(
  input: List(String),
  patterns: List(Pattern),
) -> List(#(Int, String)) {
  case match_at_position(input, patterns, input, 0) {
    Some(result) -> [result]
    None -> []
  }
}

fn all_match_positions_loop(
  patterns: List(Pattern),
  input: List(String),
  original: List(String),
  skipped: Int,
  acc: List(#(Int, String)),
) -> List(#(Int, String)) {
  case match_at_position(input, patterns, original, skipped) {
    Some(#(start, matched_text)) -> {
      let consumed = string.length(matched_text)
      let remaining = list.drop(input, consumed)
      all_match_positions_loop(
        patterns,
        remaining,
        original,
        skipped + consumed,
        [#(start, matched_text), ..acc],
      )
    }
    None -> {
      case patterns, input {
        [Start, ..], _ -> list.reverse(acc)
        _, [] -> list.reverse(acc)
        _, [_, ..rest] ->
          all_match_positions_loop(patterns, rest, original, skipped + 1, acc)
      }
    }
  }
}

fn first_match_position_loop(
  patterns: List(Pattern),
  input: List(String),
  original: List(String),
  skipped: Int,
) -> Option(#(Int, String)) {
  case match_at_position(input, patterns, original, skipped) {
    Some(result) -> Some(result)
    None -> {
      case patterns, input {
        [Start, ..], _ -> None
        _, [] -> None
        _, [_, ..rest] ->
          first_match_position_loop(patterns, rest, original, skipped + 1)
      }
    }
  }
}

fn match_at_position(
  input: List(String),
  patterns: List(Pattern),
  original: List(String),
  skipped: Int,
) -> Option(#(Int, String)) {
  case match_pattern_list_once(input, patterns) {
    Ok(remaining) -> {
      let consumed = list.length(input) - list.length(remaining)
      case consumed > 0 {
        True -> {
          let matched_text =
            original
            |> list.drop(skipped)
            |> list.take(consumed)
            |> string.concat
          Some(#(skipped, matched_text))
        }
        False -> None
      }
    }
    Error(Nil) -> None
  }
}

fn take_chars(chars: List(String), count: Int) -> String {
  chars
  |> list.take(count)
  |> string.concat
}

fn all_matches_from_start(
  input: List(String),
  patterns: List(Pattern),
) -> List(String) {
  case match_pattern_list_once(input, patterns) {
    Ok(remaining) -> {
      let consumed = list.length(input) - list.length(remaining)
      case consumed > 0 {
        True -> [take_prefix(input, remaining)]
        False -> []
      }
    }
    Error(Nil) -> []
  }
}

fn all_matches_loop(
  patterns: List(Pattern),
  input: List(String),
) -> List(String) {
  case input {
    [] -> []
    [_, ..rest] -> {
      case match_pattern_list_once(input, patterns) {
        Ok(remaining) -> {
          let consumed = list.length(input) - list.length(remaining)
          case consumed > 0 {
            True -> [
              take_prefix(input, remaining),
              ..all_matches_loop(patterns, remaining)
            ]
            False -> all_matches_loop(patterns, rest)
          }
        }
        Error(Nil) -> all_matches_loop(patterns, rest)
      }
    }
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
  case match_at_position(input, patterns, original, skipped) {
    Some(#(_, matched_text)) -> Some(matched_text)
    None -> {
      case patterns, input {
        [Start, ..], _ -> None
        _, [] -> None
        _, [_, ..rest] ->
          first_match_loop(patterns, rest, original, skipped + 1)
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
    End -> True
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
          case match_sequence(rest_input, [OneOrMore(p), ..rest_patterns]) {
            Ok(remaining) -> Ok(remaining)
            Error(Nil) -> match_sequence(rest_input, rest_patterns)
          }
        }
        False -> Error(Nil)
      }
    }
    [c, ..rest_input], [ZeroOrMore(p), ..rest_patterns] -> {
      case match_char_pattern(c, p) {
        True -> {
          case match_sequence(rest_input, [ZeroOrMore(p), ..rest_patterns]) {
            Ok(remaining) -> Ok(remaining)
            Error(Nil) -> match_sequence(input, rest_patterns)
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
