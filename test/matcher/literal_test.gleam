import pattern_matcher

// ---- Single character matching ----

pub fn match_pattern_char_test() {
  assert pattern_matcher.match_pattern("abc", "a")
  assert !pattern_matcher.match_pattern("abc", "d")
}

pub fn match_pattern_single_char_test() {
  assert pattern_matcher.match_pattern("hello", "e")
  assert pattern_matcher.match_pattern("hello", "o")
  assert !pattern_matcher.match_pattern("hello", "x")
  assert !pattern_matcher.match_pattern("", "x")
}

// ---- Literal sequences ----

pub fn match_pattern_literal_sequence_test() {
  assert pattern_matcher.match_pattern("abc123", "abc")
  assert !pattern_matcher.match_pattern("ab123", "abc")
}

pub fn match_pattern_multi_char_patterns_test() {
  assert pattern_matcher.match_pattern("abc", "abc")
  assert pattern_matcher.match_pattern("123", "\\d\\d")
  assert !pattern_matcher.match_pattern("hello", "+")
  assert !pattern_matcher.match_pattern("", "")
}

// ---- Special characters treated as literals ----

pub fn match_pattern_single_special_chars_test() {
  assert pattern_matcher.match_pattern("a+b", "+")
  assert pattern_matcher.match_pattern("a.b", ".")
  assert pattern_matcher.match_pattern("(abc)", "(")
}
