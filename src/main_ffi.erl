-module(main_ffi).
-export([read_stdin/0, is_stdout_tty/0]).

read_stdin() ->
    unicode:characters_to_binary(read_stdin([])).

read_stdin(Acc) ->
    case io:get_line("") of
        eof -> lists:reverse(Acc);
        Line -> read_stdin([Line | Acc])
    end.

is_stdout_tty() ->
    case io:getopts() of
        Opts when is_list(Opts) ->
            lists:keyfind(terminal, 1, Opts) =:= {terminal, true};
        _ ->
            false
    end.
