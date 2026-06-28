import pattern_matcher

// ---- One or more quantifier ----

pub fn match_pattern_one_or_more_literal_test() {
  assert pattern_matcher.match_pattern("apple", "a+")
  assert pattern_matcher.match_pattern("SaaS", "a+")
  assert !pattern_matcher.match_pattern("dog", "a+")
}

pub fn match_pattern_one_or_more_literal_sequence_test() {
  assert pattern_matcher.match_pattern("cats", "ca+ts")
  assert pattern_matcher.match_pattern("caats", "ca+ts")
  assert !pattern_matcher.match_pattern("cts", "ca+ts")
}

pub fn match_pattern_one_or_more_digit_class_test() {
  assert pattern_matcher.match_pattern("123", "\\d+")
  assert pattern_matcher.match_pattern("abc123def", "\\d+")
  assert !pattern_matcher.match_pattern("no digits", "\\d+")
}

pub fn match_pattern_one_or_more_word_class_test() {
  assert pattern_matcher.match_pattern("word", "\\w+")
  assert pattern_matcher.match_pattern("hello_world", "\\w+")
  assert !pattern_matcher.match_pattern("!!!", "\\w+")
}

pub fn match_pattern_one_or_more_group_test() {
  assert pattern_matcher.match_pattern("abc", "[abc]+")
  assert pattern_matcher.match_pattern("aabbcc", "[abc]+")
  assert !pattern_matcher.match_pattern("xyz", "[abc]+")
}

pub fn match_pattern_one_or_more_negative_group_test() {
  assert pattern_matcher.match_pattern("xyz", "[^abc]+")
  assert pattern_matcher.match_pattern("def", "[^abc]+")
  assert !pattern_matcher.match_pattern("abc", "[^abc]+")
}

pub fn match_pattern_one_or_more_exact_test() {
  assert pattern_matcher.match_pattern("a", "^a+$")
  assert pattern_matcher.match_pattern("aaa", "^a+$")
  assert !pattern_matcher.match_pattern("aab", "^a+$")
  assert !pattern_matcher.match_pattern("baaa", "^a+$")
}
