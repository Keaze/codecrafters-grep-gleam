import argv
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import pattern_matcher
import pattern_parser

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
  let line = normalize_input(input)
  case pattern_matcher.first_match(line, pattern) {
    Some(matched) -> {
      io.println(matched)
      exit(0)
    }
    None -> exit(1)
  }
}

pub fn matching_lines(input: String, pattern: String) -> List(String) {
  input
  |> normalize_input
  |> string.to_graphemes
  |> pattern_parser.split_on("\n")
  |> list.map(fn(line) { string.concat(line) })
  |> list.filter(fn(line) { pattern_matcher.match_pattern(line, pattern) })
}

fn normalize_input(input: String) -> String {
  case string.ends_with(input, "\n") {
    True -> string.drop_end(input, 1)
    False -> input
  }
}

@external(erlang, "main_ffi", "read_stdin")
fn read_stdin() -> String

@external(erlang, "erlang", "halt")
pub fn exit(code: Int) -> Nil
