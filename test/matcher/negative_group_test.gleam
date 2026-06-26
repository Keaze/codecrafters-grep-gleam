import pattern_matcher

pub fn match_pattern_negative_group_matches_when_char_not_in_set_test() {
  assert pattern_matcher.match_pattern("cat", "[^abc]")
}

pub fn match_pattern_negative_group_does_not_match_when_all_chars_in_set_test() {
  assert !pattern_matcher.match_pattern("cab", "[^abc]")
}

pub fn match_pattern_negative_group_empty_input_test() {
  assert !pattern_matcher.match_pattern("", "[^abc]")
}

pub fn match_pattern_negative_group_single_non_set_char_test() {
  assert pattern_matcher.match_pattern("z", "[^abc]")
}

pub fn match_pattern_negative_group_only_set_chars_test() {
  assert !pattern_matcher.match_pattern("ab", "[^abc]")
  assert !pattern_matcher.match_pattern("ba", "[^abc]")
}

pub fn match_pattern_negative_group_special_char_not_in_set_test() {
  assert pattern_matcher.match_pattern("a+b", "[^abc]")
}

pub fn match_pattern_negative_group_digit_not_in_set_test() {
  assert pattern_matcher.match_pattern("a1b", "[^abc]")
}

pub fn match_pattern_negative_group_whitespace_test() {
  assert pattern_matcher.match_pattern(" ", "[^abc]")
}

pub fn match_pattern_negative_group_uppercase_not_in_lowercase_set_test() {
  assert pattern_matcher.match_pattern("A", "[^abc]")
}

pub fn match_pattern_negative_group_all_input_chars_outside_set_test() {
  assert pattern_matcher.match_pattern("xyz", "[^abc]")
}

pub fn match_pattern_negative_group_single_char_set_test() {
  assert pattern_matcher.match_pattern("b", "[^a]")
  assert !pattern_matcher.match_pattern("a", "[^a]")
}

pub fn match_pattern_negative_group_numeric_set_test() {
  assert pattern_matcher.match_pattern("abc", "[^123]")
  assert !pattern_matcher.match_pattern("12", "[^123]")
}

pub fn match_pattern_negative_group_mixed_input_test() {
  assert pattern_matcher.match_pattern("aaat", "[^abc]")
  assert pattern_matcher.match_pattern("abcz", "[^abc]")
}
