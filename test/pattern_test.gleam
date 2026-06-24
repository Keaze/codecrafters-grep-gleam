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

pub fn match_pattern_word_test() {
  assert patterns.match_pattern("abc", "\\w")
  assert patterns.match_pattern("abc_def", "\\w")
  assert patterns.match_pattern("_", "\\w")
  assert patterns.match_pattern("Test123", "\\w")
  assert !patterns.match_pattern("...", "\\w")
}

pub fn is_letter_returns_true_for_ascii_letters_test() {
  assert patterns.is_letter("a")
  assert patterns.is_letter("Z")
  assert patterns.is_letter("M")
}

pub fn is_letter_returns_false_for_non_letters_test() {
  assert !patterns.is_letter("1")
  assert !patterns.is_letter(" ")
  assert !patterns.is_letter("!")
  assert !patterns.is_letter("ab")
}

pub fn is_ascii_letter_boundary_cases_test() {
  assert !patterns.is_ascii_letter(96)
  assert patterns.is_ascii_letter(97)
  assert patterns.is_ascii_letter(122)
  assert !patterns.is_ascii_letter(123)
  assert !patterns.is_ascii_letter(64)
  assert patterns.is_ascii_letter(65)
  assert patterns.is_ascii_letter(90)
  assert !patterns.is_ascii_letter(91)
}

pub fn match_pattern_single_char_test() {
  assert patterns.match_pattern("hello", "e")
  assert patterns.match_pattern("hello", "o")
  assert !patterns.match_pattern("hello", "x")
  assert !patterns.match_pattern("", "x")
}

pub fn match_pattern_single_special_chars_test() {
  assert patterns.match_pattern("a+b", "+")
  assert patterns.match_pattern("a.b", ".")
  assert patterns.match_pattern("(abc)", "(")
}

pub fn match_pattern_unhandled_multi_char_patterns_test() {
  assert !patterns.match_pattern("abc", "abc")
  assert !patterns.match_pattern("123", "\\d\\d")
  assert !patterns.match_pattern("hello", "+")
  assert !patterns.match_pattern("", "")
}

pub fn contains_digit_boundary_cases_test() {
  assert patterns.contains_digit("0")
  assert patterns.contains_digit("9")
  assert !patterns.contains_digit("")
  assert !patterns.contains_digit("no digits here")
}

pub fn match_pattern_word_with_mixed_input_test() {
  assert patterns.match_pattern("...a...", "\\w")
  assert patterns.match_pattern("123", "\\w")
  assert patterns.match_pattern("___", "\\w")
  assert !patterns.match_pattern("", "\\w")
  assert !patterns.match_pattern("!@#$%", "\\w")
}

pub fn match_pattern_negative_group_matches_when_char_not_in_set_test() {
  assert patterns.match_pattern("cat", "[^abc]")
}

pub fn match_pattern_negative_group_does_not_match_when_all_chars_in_set_test() {
  assert !patterns.match_pattern("cab", "[^abc]")
}

pub fn match_pattern_negative_group_empty_input_test() {
  assert !patterns.match_pattern("", "[^abc]")
}

pub fn match_pattern_negative_group_single_non_set_char_test() {
  assert patterns.match_pattern("z", "[^abc]")
}

pub fn match_pattern_negative_group_only_set_chars_test() {
  assert !patterns.match_pattern("ab", "[^abc]")
  assert !patterns.match_pattern("ba", "[^abc]")
}

pub fn match_pattern_negative_group_special_char_not_in_set_test() {
  assert patterns.match_pattern("a+b", "[^abc]")
}

pub fn match_pattern_negative_group_digit_not_in_set_test() {
  assert patterns.match_pattern("a1b", "[^abc]")
}

pub fn match_pattern_negative_group_whitespace_test() {
  assert patterns.match_pattern(" ", "[^abc]")
}

pub fn match_pattern_negative_group_uppercase_not_in_lowercase_set_test() {
  assert patterns.match_pattern("A", "[^abc]")
}

pub fn match_pattern_negative_group_all_input_chars_outside_set_test() {
  assert patterns.match_pattern("xyz", "[^abc]")
}

pub fn match_pattern_negative_group_single_char_set_test() {
  assert patterns.match_pattern("b", "[^a]")
  assert !patterns.match_pattern("a", "[^a]")
}

pub fn match_pattern_negative_group_numeric_set_test() {
  assert patterns.match_pattern("abc", "[^123]")
  assert !patterns.match_pattern("12", "[^123]")
}

pub fn match_pattern_negative_group_mixed_input_test() {
  assert patterns.match_pattern("aaat", "[^abc]")
  assert patterns.match_pattern("abcz", "[^abc]")
}

// Sequence matching tests
pub fn match_pattern_digit_followed_by_literal_test() {
  assert patterns.match_pattern("1 apple", "\\d apple")
}

pub fn match_pattern_digit_followed_by_literal_no_match_test() {
  assert !patterns.match_pattern("1 orange", "\\d apple")
}

pub fn match_pattern_three_digits_followed_by_apples_test() {
  assert patterns.match_pattern(
    "I got 100 apples from the store",
    "\\d\\d\\d apples",
  )
}

pub fn match_pattern_three_digits_followed_by_apples_no_match_test() {
  assert !patterns.match_pattern(
    "I got 1 apple from the store",
    "\\d\\d\\d apples",
  )
}

pub fn match_pattern_digit_word_sequence_test() {
  assert patterns.match_pattern("4 cats", "\\d \\w\\w\\ws")
}

pub fn match_pattern_digit_word_sequence_no_match_test() {
  assert !patterns.match_pattern("1 dog", "\\d \\w\\w\\ws")
}

pub fn parse_single_pattern_test() {
  assert patterns.parse_combined_pattern("\\d") == patterns.Digit
  assert patterns.parse_combined_pattern("\\w") == patterns.Word
  assert patterns.parse_combined_pattern("w") == patterns.Char("w")
}

pub fn parse_multi_class_pattern_test() {
  assert patterns.parse_combined_pattern("\\d\\d")
    == patterns.PatternList([patterns.Digit, patterns.Digit])
  assert patterns.parse_combined_pattern("\\w\\d")
    == patterns.PatternList([patterns.Word, patterns.Digit])
  assert patterns.parse_combined_pattern("was")
    == patterns.PatternList([
      patterns.Char("w"),
      patterns.Char("a"),
      patterns.Char("s"),
    ])

  assert patterns.parse_combined_pattern("\\d\\d\\d apples")
    == patterns.PatternList([
      patterns.Digit,
      patterns.Digit,
      patterns.Digit,
      patterns.Char(" "),
      patterns.Char("a"),
      patterns.Char("p"),
      patterns.Char("p"),
      patterns.Char("l"),
      patterns.Char("e"),
      patterns.Char("s"),
    ])
}

pub fn parse_single_pattern_group_test() {
  assert patterns.parse_combined_pattern("[abc]") == patterns.Group("abc")
  assert patterns.parse_combined_pattern("[c]") == patterns.Group("c")
  assert patterns.parse_combined_pattern("[]") == patterns.Group("")
}

pub fn parse_multi_class_pattern_with_group_test() {
  assert patterns.parse_combined_pattern("a[abc]\\d")
    == patterns.PatternList([
      patterns.Char("a"),
      patterns.Group("abc"),
      patterns.Digit,
    ])
}
