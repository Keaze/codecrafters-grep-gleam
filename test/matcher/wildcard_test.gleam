import pattern_matcher

// ---- Wildcard ----

pub fn match_pattern_wildcard_single_char_test() {
  assert pattern_matcher.match_pattern("a", ".")
  assert pattern_matcher.match_pattern("1", ".")
  assert pattern_matcher.match_pattern(" ", ".")
  assert pattern_matcher.match_pattern("ab", ".")
  assert !pattern_matcher.match_pattern("", ".")
}

pub fn match_pattern_wildcard_in_sequence_test() {
  assert pattern_matcher.match_pattern("abc", "a.c")
  assert pattern_matcher.match_pattern("a1c", "a.c")
  assert pattern_matcher.match_pattern("a c", "a.c")
  assert !pattern_matcher.match_pattern("ac", "a.c")
  assert !pattern_matcher.match_pattern("abbc", "a.c")
}

pub fn match_pattern_multiple_wildcards_test() {
  assert pattern_matcher.match_pattern("ab", "..")
  assert pattern_matcher.match_pattern("12", "..")
  assert pattern_matcher.match_pattern("abc", "..")
  assert !pattern_matcher.match_pattern("a", "..")
}

pub fn match_pattern_wildcard_exact_test() {
  assert pattern_matcher.match_pattern("a", "^.$")
  assert !pattern_matcher.match_pattern("ab", "^.$")
  assert !pattern_matcher.match_pattern("", "^.$")
}

pub fn match_pattern_wildcard_with_quantifiers_test() {
  assert pattern_matcher.match_pattern("abc", ".+")
  assert pattern_matcher.match_pattern("a", ".+")
  assert pattern_matcher.match_pattern("", ".*")
  assert pattern_matcher.match_pattern("anything", ".*")
}
