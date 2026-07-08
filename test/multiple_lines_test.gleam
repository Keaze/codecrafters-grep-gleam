import main as grep

pub fn matching_lines_returns_all_lines_with_digits_test() {
  assert grep.matching_lines("line1\nline_two\nline3", "\\d")
    == [
      "line1",
      "line3",
    ]
}

pub fn matching_lines_returns_empty_list_when_no_lines_match_test() {
  assert grep.matching_lines("first_line\nsecond_line", "\\d") == []
}

pub fn matching_lines_ignores_one_trailing_newline_test() {
  assert grep.matching_lines("first_line\n2nd_line\n3rd_line\n", "\\d")
    == [
      "2nd_line",
      "3rd_line",
    ]
}
