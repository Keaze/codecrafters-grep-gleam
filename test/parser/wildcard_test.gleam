import pattern_parser

// ---- Wildcard ----

pub fn parse_wildcard_test() {
  assert pattern_parser.parse_combined_pattern(".") == pattern_parser.Wildcard
}

pub fn parse_wildcard_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("a.c")
    == pattern_parser.Sequence([
      pattern_parser.Char("a"),
      pattern_parser.Wildcard,
      pattern_parser.Char("c"),
    ])
}

pub fn parse_multiple_wildcards_test() {
  assert pattern_parser.parse_combined_pattern("..")
    == pattern_parser.Sequence([
      pattern_parser.Wildcard,
      pattern_parser.Wildcard,
    ])
}

pub fn parse_wildcard_with_quantifiers_test() {
  assert pattern_parser.parse_combined_pattern(".+")
    == pattern_parser.OneOrMore(pattern_parser.Wildcard)
  assert pattern_parser.parse_combined_pattern(".*")
    == pattern_parser.ZeroOrMore(pattern_parser.Wildcard)
  assert pattern_parser.parse_combined_pattern(".?")
    == pattern_parser.Optional(pattern_parser.Wildcard)
}
