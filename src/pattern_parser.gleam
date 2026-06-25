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
