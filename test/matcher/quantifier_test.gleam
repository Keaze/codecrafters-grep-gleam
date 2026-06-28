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

// ---- None or one quantifier ----

pub fn match_pattern_none_or_one_literal_test() {
  assert pattern_matcher.match_pattern("apple", "a?")
  assert pattern_matcher.match_pattern("dog", "a?")
}

pub fn match_pattern_none_or_one_literal_sequence_test() {
  assert pattern_matcher.match_pattern("cats", "ca?ts")
  assert pattern_matcher.match_pattern("cts", "ca?ts")
  assert !pattern_matcher.match_pattern("caats", "ca?ts")
  assert !pattern_matcher.match_pattern("car", "ca?ts")
  assert !pattern_matcher.match_pattern("cat", "ca?ts")
}

pub fn match_pattern_none_or_one_digit_class_test() {
  assert pattern_matcher.match_pattern("123", "\\d?")
  assert pattern_matcher.match_pattern("abc", "\\d?")
}

pub fn match_pattern_none_or_one_word_class_test() {
  assert pattern_matcher.match_pattern("word", "\\w?")
  assert pattern_matcher.match_pattern("!!!", "\\w?")
}

pub fn match_pattern_none_or_one_group_test() {
  assert pattern_matcher.match_pattern("abc", "[abc]?")
  assert pattern_matcher.match_pattern("xyz", "[abc]?")
}

pub fn match_pattern_none_or_one_negative_group_test() {
  assert pattern_matcher.match_pattern("xyz", "[^abc]?")
  assert pattern_matcher.match_pattern("abc", "[^abc]?")
}

pub fn match_pattern_none_or_one_exact_test() {
  assert pattern_matcher.match_pattern("a", "^a?$")
  assert pattern_matcher.match_pattern("", "^a?$")
  assert !pattern_matcher.match_pattern("aa", "^a?$")
  assert pattern_matcher.match_pattern("cats", "^ca?ts$")
  assert pattern_matcher.match_pattern("cts", "^ca?ts$")
  assert !pattern_matcher.match_pattern("caats", "^ca?ts$")
}

// ---- Zero or more quantifier ----

pub fn match_pattern_zero_or_more_literal_test() {
  assert pattern_matcher.match_pattern("apple", "a*")
  assert pattern_matcher.match_pattern("dog", "a*")
  assert pattern_matcher.match_pattern("", "a*")
}

pub fn match_pattern_zero_or_more_literal_sequence_test() {
  assert pattern_matcher.match_pattern("cats", "ca*ts")
  assert pattern_matcher.match_pattern("cts", "ca*ts")
  assert pattern_matcher.match_pattern("caats", "ca*ts")
  assert !pattern_matcher.match_pattern("car", "ca*ts")
  assert !pattern_matcher.match_pattern("cat", "ca*ts")
}

pub fn match_pattern_zero_or_more_digit_class_test() {
  assert pattern_matcher.match_pattern("123", "\\d*")
  assert pattern_matcher.match_pattern("abc", "\\d*")
}

pub fn match_pattern_zero_or_more_word_class_test() {
  assert pattern_matcher.match_pattern("word", "\\w*")
  assert pattern_matcher.match_pattern("!!!", "\\w*")
}

pub fn match_pattern_zero_or_more_group_test() {
  assert pattern_matcher.match_pattern("abc", "[abc]*")
  assert pattern_matcher.match_pattern("xyz", "[abc]*")
}

pub fn match_pattern_zero_or_more_negative_group_test() {
  assert pattern_matcher.match_pattern("xyz", "[^abc]*")
  assert pattern_matcher.match_pattern("abc", "[^abc]*")
}

pub fn match_pattern_zero_or_more_exact_test() {
  assert pattern_matcher.match_pattern("aaa", "^a*$")
  assert pattern_matcher.match_pattern("", "^a*$")
  assert !pattern_matcher.match_pattern("aab", "^a*$")
  assert pattern_matcher.match_pattern("cats", "^ca*ts$")
  assert pattern_matcher.match_pattern("cts", "^ca*ts$")
  assert pattern_matcher.match_pattern("caats", "^ca*ts$")
  assert !pattern_matcher.match_pattern("cars", "^ca*ts$")
}
