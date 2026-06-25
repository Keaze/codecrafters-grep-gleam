import pattern_parser

pub fn parse_single_pattern_test() {
  assert pattern_parser.parse_combined_pattern("\\d") == pattern_parser.Digit
  assert pattern_parser.parse_combined_pattern("\\w") == pattern_parser.Word
  assert pattern_parser.parse_combined_pattern("w") == pattern_parser.Char("w")
}

pub fn parse_multi_class_pattern_test() {
  assert pattern_parser.parse_combined_pattern("\\d\\d")
    == pattern_parser.PatternList([pattern_parser.Digit, pattern_parser.Digit])
  assert pattern_parser.parse_combined_pattern("\\w\\d")
    == pattern_parser.PatternList([pattern_parser.Word, pattern_parser.Digit])
  assert pattern_parser.parse_combined_pattern("was")
    == pattern_parser.PatternList([
      pattern_parser.Char("w"),
      pattern_parser.Char("a"),
      pattern_parser.Char("s"),
    ])

  assert pattern_parser.parse_combined_pattern("\\d\\d\\d apples")
    == pattern_parser.PatternList([
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

pub fn parse_single_pattern_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]")
    == pattern_parser.Group("abc")
  assert pattern_parser.parse_combined_pattern("[c]")
    == pattern_parser.Group("c")
  assert pattern_parser.parse_combined_pattern("[]") == pattern_parser.Group("")
}

pub fn parse_single_pattern_ngroup_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]")
    == pattern_parser.NGroup("abc")
  assert pattern_parser.parse_combined_pattern("[^c]")
    == pattern_parser.NGroup("c")
  assert pattern_parser.parse_combined_pattern("[^]")
    == pattern_parser.NGroup("")
}

pub fn parse_multi_class_pattern_with_ngroup_test() {
  assert pattern_parser.parse_combined_pattern("a[^abc]\\d")
    == pattern_parser.PatternList([
      pattern_parser.Char("a"),
      pattern_parser.NGroup("abc"),
      pattern_parser.Digit,
    ])
}

pub fn parse_multi_class_pattern_with_group_test() {
  assert pattern_parser.parse_combined_pattern("a[abc]\\d")
    == pattern_parser.PatternList([
      pattern_parser.Char("a"),
      pattern_parser.Group("abc"),
      pattern_parser.Digit,
    ])
}
