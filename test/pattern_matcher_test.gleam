import pattern_matcher

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

pub fn contains_digit_returns_true_when_input_contains_a_digit_test() {
  assert pattern_matcher.contains_digit("abc123")
  assert pattern_matcher.contains_digit("9lives")
}

pub fn contains_digit_returns_false_when_input_has_no_digits_test() {
  assert !pattern_matcher.contains_digit("")
  assert !pattern_matcher.contains_digit("gleam")
  assert !pattern_matcher.contains_digit("!!!")
}

pub fn match_pattern_digit_class_returns_true_for_matching_input_test() {
  assert pattern_matcher.match_pattern("abc123", "\\d")
  assert pattern_matcher.match_pattern("7", "\\d")
}

pub fn match_pattern_digit_class_returns_false_for_non_matching_input_test() {
  assert !pattern_matcher.match_pattern("gleam", "\\d")
  assert !pattern_matcher.match_pattern("", "\\d")
}

pub fn match_pattern_literal_sequence_test() {
  assert pattern_matcher.match_pattern("abc123", "abc")
  assert !pattern_matcher.match_pattern("ab123", "abc")
}

pub fn match_pattern_char_test() {
  assert pattern_matcher.match_pattern("abc", "a")
  assert !pattern_matcher.match_pattern("abc", "d")
}

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

pub fn match_pattern_word_test() {
  assert pattern_matcher.match_pattern("abc", "\\w")
  assert pattern_matcher.match_pattern("abc_def", "\\w")
  assert pattern_matcher.match_pattern("_", "\\w")
  assert pattern_matcher.match_pattern("Test123", "\\w")
  assert !pattern_matcher.match_pattern("...", "\\w")
}

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

pub fn match_pattern_single_char_test() {
  assert pattern_matcher.match_pattern("hello", "e")
  assert pattern_matcher.match_pattern("hello", "o")
  assert !pattern_matcher.match_pattern("hello", "x")
  assert !pattern_matcher.match_pattern("", "x")
}

pub fn match_pattern_single_special_chars_test() {
  assert pattern_matcher.match_pattern("a+b", "+")
  assert pattern_matcher.match_pattern("a.b", ".")
  assert pattern_matcher.match_pattern("(abc)", "(")
}

pub fn match_pattern_multi_char_patterns_test() {
  assert pattern_matcher.match_pattern("abc", "abc")
  assert pattern_matcher.match_pattern("123", "\\d\\d")
  assert !pattern_matcher.match_pattern("hello", "+")
  assert !pattern_matcher.match_pattern("", "")
}

pub fn contains_digit_boundary_cases_test() {
  assert pattern_matcher.contains_digit("0")
  assert pattern_matcher.contains_digit("9")
  assert !pattern_matcher.contains_digit("")
  assert !pattern_matcher.contains_digit("no digits here")
}

pub fn match_pattern_word_with_mixed_input_test() {
  assert pattern_matcher.match_pattern("...a...", "\\w")
  assert pattern_matcher.match_pattern("123", "\\w")
  assert pattern_matcher.match_pattern("___", "\\w")
  assert !pattern_matcher.match_pattern("", "\\w")
  assert !pattern_matcher.match_pattern("!@#$%", "\\w")
}

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

// Sequence matching tests
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
