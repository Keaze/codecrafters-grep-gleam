import pattern_matcher

pub fn alternate_matches_first_alternative_test() {
  assert pattern_matcher.match_pattern("cat", "(cat|dog)")
}

pub fn alternate_matches_second_alternative_test() {
  assert pattern_matcher.match_pattern("dog", "(cat|dog)")
}

pub fn alternate_does_not_match_when_no_alternative_matches_test() {
  assert !pattern_matcher.match_pattern("apple", "(cat|dog)")
}

pub fn alternate_matches_when_input_contains_second_alternative_test() {
  assert pattern_matcher.match_pattern("doghouse", "(cat|dog)")
}

pub fn alternate_matches_first_alternative_in_sequence_test() {
  assert pattern_matcher.match_pattern("I like cats", "I like (cats|dogs)")
}

pub fn alternate_matches_second_alternative_in_sequence_test() {
  assert pattern_matcher.match_pattern("I like dogs", "I like (cats|dogs)")
}

pub fn alternate_matches_one_of_three_alternatives_test() {
  assert pattern_matcher.match_pattern("blue", "(red|blue|green)")
}
