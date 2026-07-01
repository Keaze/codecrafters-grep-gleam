import pattern_parser

// ---- Alternatives ----

pub fn parse_two_literal_alternatives_test() {
  assert pattern_parser.parse_combined_pattern("(cat|dog)")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([
        pattern_parser.Char("c"),
        pattern_parser.Char("a"),
        pattern_parser.Char("t"),
      ]),
      pattern_parser.Sequence([
        pattern_parser.Char("d"),
        pattern_parser.Char("o"),
        pattern_parser.Char("g"),
      ]),
    ])
}

pub fn parse_three_literal_alternatives_test() {
  assert pattern_parser.parse_combined_pattern("(red|blue|green)")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([
        pattern_parser.Char("r"),
        pattern_parser.Char("e"),
        pattern_parser.Char("d"),
      ]),
      pattern_parser.Sequence([
        pattern_parser.Char("b"),
        pattern_parser.Char("l"),
        pattern_parser.Char("u"),
        pattern_parser.Char("e"),
      ]),
      pattern_parser.Sequence([
        pattern_parser.Char("g"),
        pattern_parser.Char("r"),
        pattern_parser.Char("e"),
        pattern_parser.Char("e"),
        pattern_parser.Char("n"),
      ]),
    ])
}

pub fn parse_alternative_in_sequence_test() {
  assert pattern_parser.parse_combined_pattern("I like (cats|dogs)")
    == pattern_parser.Sequence([
      pattern_parser.Char("I"),
      pattern_parser.Char(" "),
      pattern_parser.Char("l"),
      pattern_parser.Char("i"),
      pattern_parser.Char("k"),
      pattern_parser.Char("e"),
      pattern_parser.Char(" "),
      pattern_parser.Alternative([
        pattern_parser.Sequence([
          pattern_parser.Char("c"),
          pattern_parser.Char("a"),
          pattern_parser.Char("t"),
          pattern_parser.Char("s"),
        ]),
        pattern_parser.Sequence([
          pattern_parser.Char("d"),
          pattern_parser.Char("o"),
          pattern_parser.Char("g"),
          pattern_parser.Char("s"),
        ]),
      ]),
    ])
}

pub fn parse_alternative_with_character_classes_test() {
  assert pattern_parser.parse_combined_pattern("(\\d|\\w|[abc])")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([pattern_parser.Digit]),
      pattern_parser.Sequence([pattern_parser.Word]),
      pattern_parser.Sequence([pattern_parser.Group(["a", "b", "c"])]),
    ])
}

pub fn parse_alternative_with_quantifier_test() {
  assert pattern_parser.parse_combined_pattern("(cat|dog)+")
    == pattern_parser.OneOrMore(
      pattern_parser.Alternative([
        pattern_parser.Sequence([
          pattern_parser.Char("c"),
          pattern_parser.Char("a"),
          pattern_parser.Char("t"),
        ]),
        pattern_parser.Sequence([
          pattern_parser.Char("d"),
          pattern_parser.Char("o"),
          pattern_parser.Char("g"),
        ]),
      ]),
    )
}

pub fn parse_alternative_with_empty_branch_test() {
  assert pattern_parser.parse_combined_pattern("(cat|)")
    == pattern_parser.Alternative([
      pattern_parser.Sequence([
        pattern_parser.Char("c"),
        pattern_parser.Char("a"),
        pattern_parser.Char("t"),
      ]),
      pattern_parser.Sequence([]),
    ])
}

pub fn parse_unclosed_alternative_is_invalid_test() {
  assert pattern_parser.parse_combined_pattern("(cat|dog")
    == pattern_parser.Invalid
}
