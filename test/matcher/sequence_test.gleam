import pattern_matcher

pub fn match_pattern_digit_followed_by_literal_test() {
  assert pattern_matcher.match_pattern("1 apple", "\\d apple")
}

pub fn match_pattern_digit_followed_by_literal_no_match_test() {
  assert !pattern_matcher.match_pattern("1 orange", "\\d apple")
}

pub fn match_pattern_three_digits_followed_by_apples_test() {
  assert pattern_matcher.match_pattern(
    "I got 100 apples from the store",
    "\\d\\d\\d apples",
  )
}

pub fn match_pattern_three_digits_followed_by_apples_no_match_test() {
  assert !pattern_matcher.match_pattern(
    "I got 1 apple from the store",
    "\\d\\d\\d apples",
  )
}

pub fn match_pattern_digit_word_sequence_test() {
  assert pattern_matcher.match_pattern("4 cats", "\\d \\w\\w\\ws")
}

pub fn match_pattern_digit_word_sequence_no_match_test() {
  assert !pattern_matcher.match_pattern("1 dog", "\\d \\w\\w\\ws")
}
