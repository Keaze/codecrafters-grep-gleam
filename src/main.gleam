import argv
import gleam/io
import pattern_matcher

pub fn main() {
  let args = argv.load().arguments
  let input_line = get_line("")

  // You can use print statements as follows for debugging, they'll be visible when running tests.
  io.print_error("Logs from your program will appear here!")

  case args {
    ["-E", pattern, ..] -> {
      case pattern_matcher.match_pattern(input_line, pattern) {
        True -> exit(0)
        False -> exit(1)
      }
    }
    _ -> {
      io.println("Expected first argument to be '-E'")
      exit(1)
    }
  }
}

@external(erlang, "io", "get_line")
fn get_line(prompt prompt: String) -> String

@external(erlang, "erlang", "halt")
pub fn exit(code: Int) -> Int
