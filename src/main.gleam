import argv
import gleam/io
import gleam/list
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
      let positions = pattern_matcher.all_match_positions(line, pattern)
      case positions {
        [] -> Error(Nil)
        _ -> Ok(highlight_line(line, positions))
      }
    })

  list.each(highlighted, io.println)

  case highlighted {
    [] -> exit(1)
    _ -> exit(0)
  }
}

fn highlight_line(line: String, positions: List(#(Int, String))) -> String {
  highlight_line_loop(line, positions, 0, "")
}

fn highlight_line_loop(
  line: String,
  positions: List(#(Int, String)),
  index: Int,
  acc: String,
) -> String {
  case positions {
    [] -> acc <> string.drop_start(line, index)
    [#(start, match_text), ..rest] -> {
      let before = string.slice(line, index, start - index)
      let next_index = start + string.length(match_text)
      highlight_line_loop(
        line,
        rest,
        next_index,
        acc <> before <> red_open <> match_text <> reset,
      )
    }
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
