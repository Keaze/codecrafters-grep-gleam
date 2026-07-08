-module(main_ffi).
-export([read_stdin/0]).

read_stdin() ->
    unicode:characters_to_binary(read_stdin([])).

read_stdin(Acc) ->
    case io:get_line("") of
        eof -> lists:reverse(Acc);
        Line -> read_stdin([Line | Acc])
    end.
