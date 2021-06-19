-module(connection_handler).
-export([handle/1]).

-include_lib("kernel/include/file.hrl").

-define(CONFIG_DIRECTORY_1, "/etc/gopher_erlang/handler_config.erl").

read_handler_config() ->
    {ok, Terms} = file:consult(?CONFIG_DIRECTORY_1),
    dict:from_list(Terms).

handle(Socket) -> 
  Parameters = read_handler_config(),
  {ok, BinaryMessage} = gen_tcp:recv(Socket, 0),
  case BinaryMessage of
    <<".\r\n">> -> noop;
    <<"\r\n">> -> {ok, SelectedFile} = absolute_path(<<"">>, Parameters),
                  serve_file(Socket, SelectedFile)
                  ;
    BinaryMessage -> 
      StrippedMessage = binary:part(BinaryMessage, {0, byte_size(BinaryMessage) - 2}),
      {ok, SelectedFile} = absolute_path(StrippedMessage, Parameters),
      serve_file(Socket, SelectedFile)
  end,
  gen_tcp:close(Socket).

absolute_path(BinaryMessage, Parameters) ->
  erlang:display(BinaryMessage),
  BinaryPath = BinaryMessage,
  Path = binary:bin_to_list(BinaryPath),
  % I think there is the possibility to break out
  % of the root_path at the moment (I don't check if
  % an absolute path is given).
  {ok, RootPath} = dict:find(root_path, Parameters),
  erlang:display(Path),
  erlang:display(RootPath),
  AbsolutePath = filename:join(RootPath, Path),
  erlang:display(AbsolutePath),
  {ok, FileInfo} = file:read_file_info(AbsolutePath),
  SelectedFile = case FileInfo#file_info.type of
    directory -> {ok, Index} = dict:find(index, Parameters),
                 filename:join(AbsolutePath, Index);
    _ -> AbsolutePath
  end,
  erlang:display(SelectedFile),
  {ok, SelectedFile}.

serve_file(Socket, Path) -> 
  {ok, BinaryContents} = file:read_file(Path),
  gen_tcp:send(Socket, BinaryContents),
  gen_tcp:send(Socket, ".\r\n").


