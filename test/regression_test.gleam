import main as grep
import pattern_matcher
import pattern_parser

// ---- Escaped special characters ----

pub fn parse_escaped_plus_test() {
  assert pattern_parser.parse_combined_pattern("a\\+")
    == pattern_parser.Sequence([
      pattern_parser.Char("a"),
      pattern_parser.Char("+"),
    ])
}

pub fn match_escaped_plus_test() {
  assert pattern_matcher.match_pattern("a+b", "a\\+")
  assert !pattern_matcher.match_pattern("ab", "a\\+")
}

pub fn match_escaped_dot_test() {
  assert pattern_matcher.match_pattern("a.b", "a\\.")
  assert !pattern_matcher.match_pattern("axb", "a\\.")
}

pub fn match_escaped_quantifier_test() {
  assert pattern_matcher.match_pattern("a?b", "a\\?b")
  assert pattern_matcher.match_pattern("a*b", "a\\*b")
}

// ---- Escaped delimiters inside groups ----

pub fn parse_group_with_escaped_close_bracket_test() {
  assert pattern_parser.parse_combined_pattern("[\\]]")
    == pattern_parser.Group(["]"])
}

pub fn match_group_with_escaped_close_bracket_test() {
  assert pattern_matcher.match_pattern("]", "[\\]]")
  assert !pattern_matcher.match_pattern("x", "[\\]]")
}

// ---- Escaped delimiters inside alternations ----

pub fn parse_alternative_with_escaped_close_paren_test() {
  assert pattern_parser.parse_combined_pattern("(a\\)|b)")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([
        pattern_parser.Char("a"),
        pattern_parser.Char(")"),
      ]),
      pattern_parser.Sequence([pattern_parser.Char("b")]),
    ])
}

pub fn match_alternative_with_escaped_close_paren_test() {
  assert pattern_matcher.match_pattern("a)", "(a\\)|b)")
}

pub fn match_alternative_with_escaped_pipe_test() {
  assert pattern_matcher.match_pattern("a|b", "(a\\|b|c)")
  assert pattern_matcher.match_pattern("c", "(a\\|b|c)")
  assert !pattern_matcher.match_pattern("a", "(a\\|b|c)")
}

// ---- Character classes inside alternations ----

pub fn parse_alternative_with_character_classes_test() {
  assert pattern_parser.parse_combined_pattern("(\\d|\\w|[abc])")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([pattern_parser.Digit]),
      pattern_parser.Sequence([pattern_parser.Word]),
      pattern_parser.Sequence([pattern_parser.Group(["a", "b", "c"])]),
    ])
}

// ---- Bare end anchor ----

pub fn bare_end_anchor_matches_any_line_test() {
  assert pattern_matcher.match_pattern("abc", "$")
  assert pattern_matcher.match_pattern("", "$")
}

pub fn bare_end_anchor_matching_lines_test() {
  assert grep.matching_lines("abc\ndef", "$") == ["abc", "def"]
}
