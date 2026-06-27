import pattern_parser

// ---- One or more quantifier ----

pub fn parse_one_or_more_literal_test() {
  assert pattern_parser.parse_combined_pattern("a+")
    == pattern_parser.AtLeastOne(pattern_parser.Char("a"))
}

pub fn parse_one_or_more_literal_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("ca+ts")
    == pattern_parser.PatternList([
      pattern_parser.Char("c"),
      pattern_parser.AtLeastOne(pattern_parser.Char("a")),
      pattern_parser.Char("t"),
      pattern_parser.Char("s"),
    ])
}

pub fn parse_one_or_more_digit_class_test() {
  assert pattern_parser.parse_combined_pattern("\\d+")
    == pattern_parser.AtLeastOne(pattern_parser.Digit)
}

pub fn parse_one_or_more_word_class_test() {
  assert pattern_parser.parse_combined_pattern("\\w+")
    == pattern_parser.AtLeastOne(pattern_parser.Word)
}

pub fn parse_one_or_more_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]+")
    == pattern_parser.AtLeastOne(pattern_parser.Group(["a", "b", "c"]))
}

pub fn parse_one_or_more_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]+")
    == pattern_parser.AtLeastOne(pattern_parser.NGroup(["a", "b", "c"]))
}
