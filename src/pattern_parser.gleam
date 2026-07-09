import gleam/list
import gleam/string

pub type Pattern {
  Digit
  Word
  Wildcard
  Alternative(List(Pattern))
  Group(List(String))
  NegativeGroup(List(String))
  Char(String)
  Sequence(List(Pattern))
  Invalid
  Start
  End
  Anchored(List(Pattern))
  OneOrMore(Pattern)
  ZeroOrMore(Pattern)
  Optional(Pattern)
}

pub fn parse_combined_pattern(pattern: String) -> Pattern {
  let pattern_chars = string.to_graphemes(pattern)
  let res = case pattern_chars {
    ["^", ..xs] -> parse_combined_pattern_rec(xs, [], [Start])
    x -> parse_combined_pattern_rec(x, [], [])
  }
  case res {
    Sequence([x]) -> x
    x -> x
  }
}

// Parses a pattern string into a Pattern. The accumulator `acc` is built in
// reverse order because we prepend elements, so it is reversed at the end.
fn parse_combined_pattern_rec(
  remaining: List(String),
  current_token: List(String),
  acc: List(Pattern),
) -> Pattern {
  case remaining, current_token, acc {
    [], [], _ -> Sequence(list.reverse(acc))

    ["$"], [], _ -> check_for_exact_pattern(acc)

    [".", ..rest], [], _ ->
      parse_combined_pattern_rec(rest, [], [Wildcard, ..acc])
    ["+", ..rest], [], [x, ..xs] ->
      parse_combined_pattern_rec(rest, [], [OneOrMore(x), ..xs])
    ["?", ..rest], [], [x, ..xs] ->
      parse_combined_pattern_rec(rest, [], [Optional(x), ..xs])
    ["*", ..rest], [], [x, ..xs] ->
      parse_combined_pattern_rec(rest, [], [ZeroOrMore(x), ..xs])

    [], ["\\"], _ -> Sequence(list.reverse([Char("\\"), ..acc]))

    ["\\", ..rest], [], _ -> parse_combined_pattern_rec(rest, ["\\"], acc)

    ["\\", ..rest], ["\\"], _ ->
      parse_combined_pattern_rec(rest, [], [Char("\\"), ..acc])

    [c, ..rest], ["\\"], _ ->
      parse_combined_pattern_rec(rest, [], [parse_escape_helper(c), ..acc])

    ["[", ..rest], [], _ -> {
      let #(found, group, rest_after) = scan_group(rest)
      case found, group {
        False, _ -> Sequence(list.reverse([Invalid, ..acc]))
        True, ["^", ..bs] ->
          parse_combined_pattern_rec(rest_after, [], [NegativeGroup(bs), ..acc])

        True, _ ->
          parse_combined_pattern_rec(rest_after, [], [Group(group), ..acc])
      }
    }

    ["(", ..rest], [], _ -> {
      let #(found, alt, rest_after) = scan_alternative(rest)
      case found {
        False -> Sequence(list.reverse([Invalid, ..acc]))
        True ->
          parse_combined_pattern_rec(rest_after, [], [
            parse_optional_pattern(alt),
            ..acc
          ])
      }
    }
    [c, ..rest], [], _ -> parse_combined_pattern_rec(rest, [], [Char(c), ..acc])

    _, _, _ -> Sequence(list.reverse([Invalid, ..acc]))
  }
}

fn parse_optional_pattern(alternatives: List(String)) -> Pattern {
  let result =
    split_alternatives(alternatives)
    |> list.map(parse_combined_pattern_rec(_, [], []))
  Alternative(result)
}

// Scan a character group until an unescaped `]`.
// Only `\]` and `\\` are treated as escapes; other backslashes are left
// intact so that character-class content such as `\d` keeps its original
// meaning for the matcher.
fn scan_group(items: List(String)) -> #(Bool, List(String), List(String)) {
  scan_group_rec(items, [])
}

fn scan_group_rec(
  items: List(String),
  acc: List(String),
) -> #(Bool, List(String), List(String)) {
  case items {
    [] -> #(False, list.reverse(acc), [])
    ["]", ..rest] -> #(True, list.reverse(acc), rest)
    ["\\", "]", ..rest] -> scan_group_rec(rest, ["]", ..acc])
    ["\\", "\\", ..rest] -> scan_group_rec(rest, ["\\", ..acc])
    [c, ..rest] -> scan_group_rec(rest, [c, ..acc])
  }
}

// Scan an alternation until an unescaped `)`.
// Only `\)` is treated as an escape; other backslashes are preserved so that
// branches such as `\d` and `\w` keep their special meaning.
fn scan_alternative(
  items: List(String),
) -> #(Bool, List(String), List(String)) {
  scan_alternative_rec(items, [])
}

fn scan_alternative_rec(
  items: List(String),
  acc: List(String),
) -> #(Bool, List(String), List(String)) {
  case items {
    [] -> #(False, list.reverse(acc), [])
    [")", ..rest] -> #(True, list.reverse(acc), rest)
    ["\\", ")", ..rest] -> scan_alternative_rec(rest, [")", ..acc])
    [c, ..rest] -> scan_alternative_rec(rest, [c, ..acc])
  }
}

// Split alternation contents on unescaped `|` bars.
fn split_alternatives(items: List(String)) -> List(List(String)) {
  split_alternatives_rec(items, [], [])
}

fn split_alternatives_rec(
  items: List(String),
  current: List(String),
  acc: List(List(String)),
) -> List(List(String)) {
  case items {
    [] -> list.reverse([list.reverse(current), ..acc])
    ["\\", "|", ..rest] -> split_alternatives_rec(rest, ["|", ..current], acc)
    ["|", ..rest] ->
      split_alternatives_rec(rest, [], [list.reverse(current), ..acc])
    [c, ..rest] -> split_alternatives_rec(rest, [c, ..current], acc)
  }
}

fn check_for_exact_pattern(acc: List(Pattern)) -> Pattern {
  case list.last(acc) {
    Ok(Start) ->
      list.take_while(acc, fn(p) { p != Start })
      |> list.reverse
      |> Anchored
    _ -> Sequence(list.reverse([End, ..acc]))
  }
}

fn parse_escape_helper(char: String) -> Pattern {
  case char {
    "w" -> Word
    "d" -> Digit
    "\\" -> Char("\\")
    _ -> Char(char)
  }
}

pub fn split_on(items: List(a), delimiter: a) -> List(List(a)) {
  case list.split_while(items, fn(x) { x != delimiter }) {
    #(chunk, []) -> [chunk]
    #(chunk, [_delim, ..rest]) -> [chunk, ..split_on(rest, delimiter)]
  }
}
