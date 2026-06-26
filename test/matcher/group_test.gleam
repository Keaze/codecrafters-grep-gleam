import pattern_matcher

pub fn match_pattern_group_matches_when_input_contains_any_char_test() {
  assert pattern_matcher.match_pattern("apple", "[abc]")
  assert pattern_matcher.match_pattern("cab", "[abc]")
}

pub fn match_pattern_group_does_not_match_when_input_contains_none_test() {
  assert !pattern_matcher.match_pattern("dog", "[abc]")
}

pub fn match_pattern_group_matches_numeric_chars_test() {
  assert pattern_matcher.match_pattern("a1b2c3", "[123]")
}

pub fn match_pattern_group_empty_input_test() {
  assert !pattern_matcher.match_pattern("", "[abc]")
}

pub fn match_pattern_group_single_char_test() {
  assert pattern_matcher.match_pattern("apple", "[a]")
}

pub fn match_pattern_group_emtpy_test() {
  assert !pattern_matcher.match_pattern("apple", "[]")
}

pub fn match_pattern_group_exact_char_match_test() {
  assert pattern_matcher.match_pattern("b", "[abc]")
}
