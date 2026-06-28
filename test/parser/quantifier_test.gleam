import pattern_parser

// ---- One or more quantifier ----

pub fn parse_one_or_more_literal_test() {
  assert pattern_parser.parse_combined_pattern("a+")
    == pattern_parser.OneOrMore(pattern_parser.Char("a"))
}

pub fn parse_one_or_more_literal_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("ca+ts")
    == pattern_parser.Sequence([
      pattern_parser.Char("c"),
      pattern_parser.OneOrMore(pattern_parser.Char("a")),
      pattern_parser.Char("t"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_one_or_more_digit_class_test() {
  assert pattern_parser.parse_combined_pattern("\\d+")
    == pattern_parser.OneOrMore(pattern_parser.Digit)
}

pub fn parse_one_or_more_word_class_test() {
  assert pattern_parser.parse_combined_pattern("\\w+")
    == pattern_parser.OneOrMore(pattern_parser.Word)
}

pub fn parse_one_or_more_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]+")
    == pattern_parser.OneOrMore(pattern_parser.Group(["a", "b", "c"]))
}

pub fn parse_one_or_more_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]+")
    == pattern_parser.OneOrMore(pattern_parser.NegativeGroup(["a", "b", "c"]))
}

// ---- None or one quantifier ----

pub fn parse_none_or_one_literal_test() {
  assert pattern_parser.parse_combined_pattern("a?")
    == pattern_parser.Optional(pattern_parser.Char("a"))
}

pub fn parse_none_or_one_literal_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("ca?ts")
    == pattern_parser.Sequence([
      pattern_parser.Char("c"),
      pattern_parser.Optional(pattern_parser.Char("a")),
      pattern_parser.Char("t"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_none_or_one_digit_class_test() {
  assert pattern_parser.parse_combined_pattern("\\d?")
    == pattern_parser.Optional(pattern_parser.Digit)
}

pub fn parse_none_or_one_word_class_test() {
  assert pattern_parser.parse_combined_pattern("\\w?")
    == pattern_parser.Optional(pattern_parser.Word)
}

pub fn parse_none_or_one_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]?")
    == pattern_parser.Optional(pattern_parser.Group(["a", "b", "c"]))
}

pub fn parse_none_or_one_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]?")
    == pattern_parser.Optional(pattern_parser.NegativeGroup(["a", "b", "c"]))
}

// ---- Zero or more quantifier ----

pub fn parse_zero_or_more_literal_test() {
  assert pattern_parser.parse_combined_pattern("a*")
    == pattern_parser.ZeroOrMore(pattern_parser.Char("a"))
}

pub fn parse_zero_or_more_literal_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("ca*ts")
    == pattern_parser.Sequence([
      pattern_parser.Char("c"),
      pattern_parser.ZeroOrMore(pattern_parser.Char("a")),
      pattern_parser.Char("t"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_zero_or_more_digit_class_test() {
  assert pattern_parser.parse_combined_pattern("\\d*")
    == pattern_parser.ZeroOrMore(pattern_parser.Digit)
}

pub fn parse_zero_or_more_word_class_test() {
  assert pattern_parser.parse_combined_pattern("\\w*")
    == pattern_parser.ZeroOrMore(pattern_parser.Word)
}

pub fn parse_zero_or_more_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]*")
    == pattern_parser.ZeroOrMore(pattern_parser.Group(["a", "b", "c"]))
}

pub fn parse_zero_or_more_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]*")
    == pattern_parser.ZeroOrMore(pattern_parser.NegativeGroup(["a", "b", "c"]))
}
