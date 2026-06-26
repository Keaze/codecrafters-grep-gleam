import pattern_parser

// ---- Positive groups ----

pub fn parse_single_pattern_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]")
    == pattern_parser.Group(["a", "b", "c"])
  assert pattern_parser.parse_combined_pattern("[c]")
    == pattern_parser.Group(["c"])
  assert pattern_parser.parse_combined_pattern("[]") == pattern_parser.Group([])
}

// ---- Negative groups ----

pub fn parse_single_pattern_ngroup_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]")
    == pattern_parser.NGroup(["a", "b", "c"])
  assert pattern_parser.parse_combined_pattern("[^c]")
    == pattern_parser.NGroup(["c"])
  assert pattern_parser.parse_combined_pattern("[^]")
    == pattern_parser.NGroup([])
}

// ---- Groups combined with other patterns ----

pub fn parse_multi_class_pattern_with_ngroup_test() {
  assert pattern_parser.parse_combined_pattern("a[^abc]\\d")
    == pattern_parser.PatternList([
      pattern_parser.Char("a"),
      pattern_parser.NGroup(["a", "b", "c"]),
      pattern_parser.Digit,
    ])
}

pub fn parse_multi_class_pattern_with_group_test() {
  assert pattern_parser.parse_combined_pattern("a[abc]\\d")
    == pattern_parser.PatternList([
      pattern_parser.Char("a"),
      pattern_parser.Group(["a", "b", "c"]),
      pattern_parser.Digit,
    ])
}
