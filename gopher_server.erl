-module(gopher_server).
-export([listen/0]).

-define(PORT, 1025).

listen() ->
  spawn(fun() ->
              {ok, ListenSocket} = gen_tcp:listen(?PORT, [binary, {packet, 0}, 
                                                          {active, false}]),
              loop(ListenSocket)
        end).

loop(ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  PidHandle = spawn(fun () -> connection_handler:handle(Socket) end),
  gen_tcp:controlling_process(Socket, PidHandle),
  loop(ListenSocket).


