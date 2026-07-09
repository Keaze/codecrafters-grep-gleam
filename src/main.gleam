import argv
import gleam/io
import gleam/list
import gleam/option.{None, Some}
import gleam/string
import pattern_matcher

const red_open = "\u{001b}[01;31m"

const reset = "\u{001b}[m"

pub fn main() -> Nil {
  let args = argv.load().arguments
  case args {
    ["--color=always", "-E", pattern, ..] ->
      run_highlight(read_stdin(), pattern)
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

fn run_highlight(input: String, pattern: String) -> Nil {
  let highlighted =
    input
    |> drop_trailing_newline
    |> string.split("\n")
    |> list.filter_map(fn(line) {
      case pattern_matcher.first_match_position(line, pattern) {
        Some(#(start, match_text)) -> {
          let before = string.slice(line, 0, start)
          let after = string.drop_start(line, start + string.length(match_text))
          Ok(before <> red_open <> match_text <> reset <> after)
        }
        None -> Error(Nil)
      }
    })

  list.each(highlighted, io.println)

  case highlighted {
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
