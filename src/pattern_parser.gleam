import gleam/list
import gleam/string

pub type Pattern {
  Digit
  Word
  Group(List(String))
  NGroup(List(String))
  Char(String)
  PatternList(List(Pattern))
  Invalid
  Start
  End
  Exact(List(Pattern))
  AtLeastOne(Pattern)
}

pub fn parse_combined_pattern(pattern: String) -> Pattern {
  let pattern_chars = string.to_graphemes(pattern)
  let res = case pattern_chars {
    ["^", ..xs] -> parse_combined_pattern_rec(xs, [], [Start])
    x -> parse_combined_pattern_rec(x, [], [])
  }
  case res {
    PatternList([x]) -> x
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
    [], [], _ -> PatternList(list.reverse(acc))

    ["$"], [], _ -> check_for_exact_pattern(acc)

    ["+", ..rest], [], [x, ..xs] ->
      parse_combined_pattern_rec(rest, [], [AtLeastOne(x), ..xs])

    [], ["\\"], _ -> PatternList(list.reverse([Char("\\"), ..acc]))

    ["\\", ..rest], [], _ -> parse_combined_pattern_rec(rest, ["\\"], acc)

    ["\\", ..rest], ["\\"], _ ->
      parse_combined_pattern_rec(rest, [], [Char("\\"), ..acc])

    [c, ..rest], ["\\"], _ ->
      parse_combined_pattern_rec(rest, [], [parse_escape_helper(c), ..acc])

    ["[", ..rest], [], _ -> {
      let #(group, rest_after) = list.split_while(rest, fn(x) { x != "]" })
      case group, rest_after {
        ["^", ..bs], [_, ..xs] ->
          parse_combined_pattern_rec(xs, [], [NGroup(bs), ..acc])

        _, [_, ..xs] ->
          parse_combined_pattern_rec(xs, [], [Group(group), ..acc])

        _, [] -> PatternList(list.reverse([Invalid, ..acc]))
      }
    }

    [c, ..rest], [], _ -> parse_combined_pattern_rec(rest, [], [Char(c), ..acc])

    _, _, _ -> PatternList(list.reverse([Invalid, ..acc]))
  }
}

fn check_for_exact_pattern(acc: List(Pattern)) -> Pattern {
  case list.last(acc) {
    Ok(Start) ->
      list.take_while(acc, fn(p) { p != Start })
      |> list.reverse
      |> Exact
    _ -> PatternList(list.reverse([End, ..acc]))
  }
}

fn parse_escape_helper(char: String) -> Pattern {
  case char {
    "w" -> Word
    "d" -> Digit
    "\\" -> Char("\\")
    _ -> Char("\\" <> char)
  }
}
