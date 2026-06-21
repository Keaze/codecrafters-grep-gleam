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

pub fn match_pattern_word_test() {
  assert patterns.match_pattern("abc", "\\w")
  assert patterns.match_pattern("abc_def", "\\w")
  assert patterns.match_pattern("_", "\\w")
  assert patterns.match_pattern("Test123", "\\w")
  assert !patterns.match_pattern("...", "\\w")
}
