import pattern_matcher

// ---- is_digit helper ----

pub fn is_digit_returns_true_for_numeric_graphemes_test() {
  assert pattern_matcher.is_digit("0")
  assert pattern_matcher.is_digit("5")
  assert pattern_matcher.is_digit("9")
}

pub fn is_digit_returns_false_for_non_digits_test() {
  assert !pattern_matcher.is_digit("a")
  assert !pattern_matcher.is_digit(" ")
  assert !pattern_matcher.is_digit("12")
}

// ---- contains_digit helper ----

pub fn contains_digit_returns_true_when_input_contains_a_digit_test() {
  assert pattern_matcher.contains_digit("abc123")
  assert pattern_matcher.contains_digit("9lives")
}

pub fn contains_digit_returns_false_when_input_has_no_digits_test() {
  assert !pattern_matcher.contains_digit("")
  assert !pattern_matcher.contains_digit("gleam")
  assert !pattern_matcher.contains_digit("!!!")
}

pub fn contains_digit_boundary_cases_test() {
  assert pattern_matcher.contains_digit("0")
  assert pattern_matcher.contains_digit("9")
  assert !pattern_matcher.contains_digit("")
  assert !pattern_matcher.contains_digit("no digits here")
}

// ---- \\d pattern matching ----

pub fn match_pattern_digit_class_returns_true_for_matching_input_test() {
  assert pattern_matcher.match_pattern("abc123", "\\d")
  assert pattern_matcher.match_pattern("7", "\\d")
}

pub fn match_pattern_digit_class_returns_false_for_non_matching_input_test() {
  assert !pattern_matcher.match_pattern("gleam", "\\d")
  assert !pattern_matcher.match_pattern("", "\\d")
}
