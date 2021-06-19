-module(gopher_server).
-export([listen/0]).

-define(CONFIG_DIRECTORY_1, "/etc/gopher_erlang/config.erl").

read_main_config() ->
  {ok, Terms} = file:consult(?CONFIG_DIRECTORY_1),
  dict:from_list(Terms).

listen() ->
  Parameters = read_main_config(),  
  {ok, Port} = dict:find(port, Parameters),
  spawn(fun() ->
              {ok, ListenSocket} = gen_tcp:listen(Port, [binary, {packet, 0},
                                                        {active, false}]),
              loop(ListenSocket)
        end).

loop(ListenSocket) ->
  {ok, Socket} = gen_tcp:accept(ListenSocket),
  PidHandle = spawn(fun () -> connection_handler:handle(Socket) end),
  gen_tcp:controlling_process(Socket, PidHandle),
  loop(ListenSocket).


