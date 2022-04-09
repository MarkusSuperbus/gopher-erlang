-module('gopher_server_app').
-behaviour(application).
-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  {ok, gopher_server:listen()}.

stop(_State) ->
  ok.
