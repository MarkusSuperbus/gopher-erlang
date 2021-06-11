-module(minimal).
-export([listen/0]).
-define(PORT, 1025).

listen() ->
  {ok, ListenSocket} = gen_tcp:listen(?PORT, [binary, {packet, 0}, {active, false}]),
  loop(ListenSocket).

loop(ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  PidHandle = spawn(fun () -> handle(Socket) end),
  gen_tcp:controlling_process(Socket, PidHandle),
  loop(ListenSocket).

handle(Socket) -> 
  {ok, BinaryMessage} = gen_tcp:recv(Socket, 0),
  erlang:display(BinaryMessage),
  case BinaryMessage of
    <<".\r\n">> -> gen_tcp:close(Socket);
    <<"\r\n">> -> list_folder(Socket, <<".">>), handle(Socket);
    BinaryMessage -> 
      StrippedMessage = binary:part(BinaryMessage, {0, byte_size(BinaryMessage) - 2}),
      list_folder(Socket, StrippedMessage), handle(Socket)
  end.

list_folder(Socket, BinaryPath) ->
  Path = binary:bin_to_list(BinaryPath),
  % I don't like this error-driven
  % branching. But it suffices for now.
  case file:list_dir(Path) of
    {ok, Filenames} -> ResponseAsString = lists:flatten([F ++ "\r\n" || F <- Filenames]),
      gen_tcp:send(Socket, list_to_binary(ResponseAsString));
    {error, enotdir} -> serve_file(Socket, Path)
  end.

serve_file(Socket, Path) -> 
  {ok, BinaryContents} = file:read_file(Path),
  gen_tcp:send(Socket, BinaryContents).
