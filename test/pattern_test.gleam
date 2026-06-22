import patterns

pub fn is_digit_returns_true_for_numeric_graphemes_test() {
  assert patterns.is_digit("0")
  assert patterns.is_digit("5")
  assert patterns.is_digit("9")
}

pub fn is_digit_returns_false_for_non_digits_test() {
  assert !patterns.is_digit("a")
  assert !patterns.is_digit(" ")
  assert !patterns.is_digit("12")
}

pub fn contains_digit_returns_true_when_input_contains_a_digit_test() {
  assert patterns.contains_digit("abc123")
  assert patterns.contains_digit("9lives")
}

pub fn contains_digit_returns_false_when_input_has_no_digits_test() {
  assert !patterns.contains_digit("")
  assert !patterns.contains_digit("gleam")
  assert !patterns.contains_digit("!!!")
}

pub fn match_pattern_digit_class_returns_true_for_matching_input_test() {
  assert patterns.match_pattern("abc123", "\\d")
  assert patterns.match_pattern("7", "\\d")
}

pub fn match_pattern_digit_class_returns_false_for_non_matching_input_test() {
  assert !patterns.match_pattern("gleam", "\\d")
  assert !patterns.match_pattern("", "\\d")
}

pub fn match_pattern_returns_false_for_unhandled_patterns_test() {
  assert !patterns.match_pattern("abc123", "abc")
}

pub fn match_pattern_char_test() {
  assert patterns.match_pattern("abc", "a")
  assert !patterns.match_pattern("abc", "d")
}

pub fn match_pattern_group_matches_when_input_contains_any_char_test() {
  assert patterns.match_pattern("apple", "[abc]")
  assert patterns.match_pattern("cab", "[abc]")
}

pub fn match_pattern_group_does_not_match_when_input_contains_none_test() {
  assert !patterns.match_pattern("dog", "[abc]")
}

pub fn match_pattern_group_matches_numeric_chars_test() {
  assert patterns.match_pattern("a1b2c3", "[123]")
}

pub fn match_pattern_group_empty_input_test() {
  assert !patterns.match_pattern("", "[abc]")
}

pub fn match_pattern_group_single_char_test() {
  assert patterns.match_pattern("apple", "[a]")
}

pub fn match_pattern_group_emtpy_test() {
  assert !patterns.match_pattern("apple", "[]")
}

pub fn match_pattern_group_exact_char_match_test() {
  assert patterns.match_pattern("b", "[abc]")
}
