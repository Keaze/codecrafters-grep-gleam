import gleam/list
import gleam/string

pub type Pattern {
  Digit
  Word
  Group(String)
  NGroup(String)
  Char(String)
  PatternList(List(Pattern))
  Empty
  Invalid
}

pub fn parse_combined_pattern(pattern: String) -> Pattern {
  let res = parse_combined_pattern_rec(string.to_graphemes(pattern), [], [])
  case res {
    PatternList([x]) -> x
    x -> x
  }
}

fn parse_combined_pattern_rec(
  remaining: List(String),
  current_token: List(String),
  acc: List(Pattern),
) -> Pattern {
  case remaining, current_token {
    [], [] -> PatternList(list.reverse(acc))
    [], ["\\"] -> PatternList(list.reverse([parse_escape_helper("\\"), ..acc]))

    ["\\", ..rest], [] -> parse_combined_pattern_rec(rest, ["\\"], acc)
    ["\\", ..rest], ["\\"] -> parse_combined_pattern_rec(rest, ["\\"], acc)

    [c, ..rest], ["\\"] ->
      parse_combined_pattern_rec(rest, [], [parse_escape_helper(c), ..acc])

    ["[", ..], [] -> {
      let #(group, rest) =
        list.drop(remaining, 1)
        |> list.split_while(fn(x) { x != "]" })
      case group, rest {
        ["^", ..bs], [_, ..xs] ->
          parse_combined_pattern_rec(xs, [], [NGroup(string.concat(bs)), ..acc])

        _, [_, ..xs] ->
          parse_combined_pattern_rec(xs, [], [
            Group(string.concat(group)),
            ..acc
          ])

        _, [] -> PatternList(list.reverse([Invalid, ..acc]))
      }
    }

    [c, ..rest], [] -> parse_combined_pattern_rec(rest, [], [Char(c), ..acc])

    _, _ -> PatternList(list.reverse([Invalid, ..acc]))
  }
}

fn parse_escape_helper(char: String) -> Pattern {
  case char {
    "w" -> Word
    "d" -> Digit
    _ -> Char("\\" <> char)
  }
}

pub fn match_pattern(input_line: String, pattern: String) -> Bool {
  let pattern = parse_combined_pattern(pattern)
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
  match_pattern_list_loop(string.to_graphemes(input_line), patterns)
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
