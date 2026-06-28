import pattern_parser

// ---- Single patterns ----

pub fn parse_single_pattern_test() {
  assert pattern_parser.parse_combined_pattern("\\d") == pattern_parser.Digit
  assert pattern_parser.parse_combined_pattern("\\w") == pattern_parser.Word
  assert pattern_parser.parse_combined_pattern("w") == pattern_parser.Char("w")
}

// ---- Multi-class / literal sequences ----

pub fn parse_multi_class_pattern_test() {
  assert pattern_parser.parse_combined_pattern("\\d\\d")
    == pattern_parser.Sequence([pattern_parser.Digit, pattern_parser.Digit])
  assert pattern_parser.parse_combined_pattern("\\w\\d")
    == pattern_parser.Sequence([pattern_parser.Word, pattern_parser.Digit])
  assert pattern_parser.parse_combined_pattern("was")
    == pattern_parser.Sequence([
      pattern_parser.Char("w"),
      pattern_parser.Char("a"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_mixed_literal_and_class_sequence_test() {
  assert pattern_parser.parse_combined_pattern("\\d\\d\\d apples")
    == pattern_parser.Sequence([
      pattern_parser.Digit,
      pattern_parser.Digit,
      pattern_parser.Digit,
      pattern_parser.Char(" "),
      pattern_parser.Char("a"),
      pattern_parser.Char("p"),
      pattern_parser.Char("p"),
      pattern_parser.Char("l"),
      pattern_parser.Char("e"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_escaped_backslash_test() {
  assert pattern_parser.parse_combined_pattern("\\\\")
    == pattern_parser.Char("\\")
}

pub fn parse_escaped_backslash_sequence_test() {
  assert pattern_parser.parse_combined_pattern("\\\\d")
    == pattern_parser.Sequence([
      pattern_parser.Char("\\"),
      pattern_parser.Char("d"),
    ])
}
