import pattern_matcher
import pattern_parser

// ---- Parser: Start anchor (^ at beginning) ----

pub fn parse_start_pattern_test() {
  assert pattern_parser.parse_combined_pattern("^abc")
    == pattern_parser.Sequence([
      pattern_parser.Start,
      pattern_parser.Char("a"),
      pattern_parser.Char("b"),
      pattern_parser.Char("c"),
    ])
}

pub fn parse_start_pattern_single_char_test() {
  assert pattern_parser.parse_combined_pattern("^a")
    == pattern_parser.Sequence([
      pattern_parser.Start,
      pattern_parser.Char("a"),
    ])
}

pub fn parse_start_pattern_digit_class_test() {
  assert pattern_parser.parse_combined_pattern("^\\d")
    == pattern_parser.Sequence([
      pattern_parser.Start,
      pattern_parser.Digit,
    ])
}

pub fn parse_start_pattern_group_test() {
  assert pattern_parser.parse_combined_pattern("^[abc]")
    == pattern_parser.Sequence([
      pattern_parser.Start,
      pattern_parser.Group(["a", "b", "c"]),
    ])
}

pub fn parse_start_pattern_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("^[^abc]")
    == pattern_parser.Sequence([
      pattern_parser.Start,
      pattern_parser.NegativeGroup(["a", "b", "c"]),
    ])
}

pub fn parse_only_start_anchor_test() {
  assert pattern_parser.parse_combined_pattern("^") == pattern_parser.Start
}

// ---- Parser: End anchor ($ at end) ----

pub fn parse_end_pattern_test() {
  assert pattern_parser.parse_combined_pattern("abc$")
    == pattern_parser.Sequence([
      pattern_parser.Char("a"),
      pattern_parser.Char("b"),
      pattern_parser.Char("c"),
      pattern_parser.End,
    ])
}

pub fn parse_end_pattern_single_char_test() {
  assert pattern_parser.parse_combined_pattern("a$")
    == pattern_parser.Sequence([
      pattern_parser.Char("a"),
      pattern_parser.End,
    ])
}

pub fn parse_end_pattern_word_class_test() {
  assert pattern_parser.parse_combined_pattern("\\w$")
    == pattern_parser.Sequence([
      pattern_parser.Word,
      pattern_parser.End,
    ])
}

pub fn parse_end_pattern_group_test() {
  assert pattern_parser.parse_combined_pattern("[abc]$")
    == pattern_parser.Sequence([
      pattern_parser.Group(["a", "b", "c"]),
      pattern_parser.End,
    ])
}

pub fn parse_end_pattern_negative_group_test() {
  assert pattern_parser.parse_combined_pattern("[^abc]$")
    == pattern_parser.Sequence([
      pattern_parser.NegativeGroup(["a", "b", "c"]),
      pattern_parser.End,
    ])
}

// ---- Parser: Start and end anchor combined ----

pub fn parse_start_and_end_pattern_test() {
  assert pattern_parser.parse_combined_pattern("^abc$")
    == pattern_parser.Anchored([
      pattern_parser.Char("a"),
      pattern_parser.Char("b"),
      pattern_parser.Char("c"),
    ])
}

// ---- Matcher: Start anchor (^ at beginning) ----

pub fn match_pattern_start_anchor_at_beginning_test() {
  assert pattern_matcher.match_pattern("abc", "^abc")
}

pub fn match_pattern_start_anchor_not_at_beginning_test() {
  assert !pattern_matcher.match_pattern("xabc", "^abc")
}

pub fn match_pattern_start_anchor_with_digit_class_test() {
  assert pattern_matcher.match_pattern("123", "^\\d")
}

pub fn match_pattern_start_anchor_with_group_test() {
  assert pattern_matcher.match_pattern("apple", "^[abc]")
}

// ---- Matcher: End anchor ($ at end) ----

pub fn match_pattern_end_anchor_at_end_test() {
  assert pattern_matcher.match_pattern("abc", "abc$")
}

pub fn match_pattern_end_anchor_not_at_end_test() {
  assert !pattern_matcher.match_pattern("abcd", "abc$")
}

pub fn match_pattern_end_anchor_with_digit_class_test() {
  assert pattern_matcher.match_pattern("123", "\\d$")
}

pub fn match_pattern_end_anchor_with_group_test() {
  assert pattern_matcher.match_pattern("cab", "[abc]$")
}

// ---- Matcher: Start and end anchor combined ----

pub fn match_pattern_exact_match_with_anchors_test() {
  assert pattern_matcher.match_pattern("abc", "^abc$")
}

pub fn match_pattern_exact_match_with_anchors_no_match_test() {
  assert !pattern_matcher.match_pattern("xabcx", "^abc$")
}

pub fn match_pattern_exact_match_anchors_banana_underscore_banana_test() {
  assert !pattern_matcher.match_pattern("banana_banana", "^banana$")
}

pub fn match_pattern_start_anchor_only_test() {
  assert pattern_matcher.match_pattern("abc", "^")
  assert pattern_matcher.match_pattern("", "^")
}
