import pattern_matcher

// ---- is_letter helper ----

pub fn is_letter_returns_true_for_ascii_letters_test() {
  assert pattern_matcher.is_letter("a")
  assert pattern_matcher.is_letter("Z")
  assert pattern_matcher.is_letter("M")
}

pub fn is_letter_returns_false_for_non_letters_test() {
  assert !pattern_matcher.is_letter("1")
  assert !pattern_matcher.is_letter(" ")
  assert !pattern_matcher.is_letter("!")
  assert !pattern_matcher.is_letter("ab")
}

pub fn is_ascii_letter_boundary_cases_test() {
  assert !pattern_matcher.is_ascii_letter(96)
  assert pattern_matcher.is_ascii_letter(97)
  assert pattern_matcher.is_ascii_letter(122)
  assert !pattern_matcher.is_ascii_letter(123)
  assert !pattern_matcher.is_ascii_letter(64)
  assert pattern_matcher.is_ascii_letter(65)
  assert pattern_matcher.is_ascii_letter(90)
  assert !pattern_matcher.is_ascii_letter(91)
}

// ---- \\w pattern matching ----

pub fn match_pattern_word_test() {
  assert pattern_matcher.match_pattern("abc", "\\w")
  assert pattern_matcher.match_pattern("abc_def", "\\w")
  assert pattern_matcher.match_pattern("_", "\\w")
  assert pattern_matcher.match_pattern("Test123", "\\w")
  assert !pattern_matcher.match_pattern("...", "\\w")
}

pub fn match_pattern_word_with_mixed_input_test() {
  assert pattern_matcher.match_pattern("...a...", "\\w")
  assert pattern_matcher.match_pattern("123", "\\w")
  assert pattern_matcher.match_pattern("___", "\\w")
  assert !pattern_matcher.match_pattern("", "\\w")
  assert !pattern_matcher.match_pattern("!@#$%", "\\w")
}
