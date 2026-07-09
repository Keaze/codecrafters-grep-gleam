import argv
import gleam/io
import gleam/list
import gleam/string
import pattern_matcher

pub fn main() -> Nil {
  let args = argv.load().arguments
  case args {
    ["-o", "-E", pattern, ..] -> run_only_matching(read_stdin(), pattern)
    ["-E", pattern, ..] -> run_normal(read_stdin(), pattern)
    _ -> {
      io.println_error("Expected first argument to be '-E'")
      exit(1)
    }
  }
}

fn run_normal(input: String, pattern: String) -> Nil {
  let matches = matching_lines(input, pattern)
  list.each(matches, io.println)

  case matches {
    [] -> exit(1)
    _ -> exit(0)
  }
}

fn run_only_matching(input: String, pattern: String) -> Nil {
  let matches = only_matching_texts(input, pattern)
  list.each(matches, io.println)

  case matches {
    [] -> exit(1)
    _ -> exit(0)
  }
}

pub fn only_matching_texts(input: String, pattern: String) -> List(String) {
  input
  |> drop_trailing_newline
  |> string.split("\n")
  |> list.map(fn(line) { pattern_matcher.all_matches(line, pattern) })
  |> list.flatten
}

pub fn matching_lines(input: String, pattern: String) -> List(String) {
  input
  |> drop_trailing_newline
  |> string.split("\n")
  |> list.filter(fn(line) { pattern_matcher.match_pattern(line, pattern) })
}

fn drop_trailing_newline(input: String) -> String {
  case string.ends_with(input, "\n") {
    True -> string.drop_end(input, 1)
    False -> input
  }
}

@external(erlang, "main_ffi", "read_stdin")
fn read_stdin() -> String

@external(erlang, "erlang", "halt")
pub fn exit(code: Int) -> Nil
