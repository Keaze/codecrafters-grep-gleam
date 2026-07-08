import main as grep
import pattern_matcher

pub fn all_matches_returns_each_digit_match_test() {
  assert pattern_matcher.all_matches("The king had 10 children", "\\d")
    == [
      "1",
      "0",
    ]
}

pub fn all_matches_returns_each_alternative_match_test() {
  assert pattern_matcher.all_matches("jekyll and hyde", "(jekyll|hyde)")
    == [
      "jekyll",
      "hyde",
    ]
}

pub fn all_matches_returns_non_overlapping_sequence_matches_test() {
  assert pattern_matcher.all_matches("The king had 10 children", "\\d\\d")
    == [
      "10",
    ]
}

pub fn all_matches_returns_greedy_quantifier_matches_test() {
  assert pattern_matcher.all_matches("abc123def45", "\\d+") == ["123", "45"]
}

pub fn all_matches_returns_empty_list_when_no_matches_test() {
  assert pattern_matcher.all_matches("jekyll and hyde", "\\d") == []
}

pub fn only_matching_texts_returns_matches_from_each_line_test() {
  assert grep.only_matching_texts("a1\nb2\n", "\\d") == ["1", "2"]
}
