-module(connection_handler).
-export([handle/1]).
-define(PORT, 1025).

-include_lib("kernel/include/file.hrl").

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
    {ok, Filenames} -> 
      Prefix = case Path of
                 "." -> "";
                 Path -> Path ++ "/"
               end,
      ResponseAsString = 
        lists:flatten([check_item_type(Prefix++F) ++ Prefix++F ++ "\t" 
                       ++ Prefix++F ++ "\t" ++ integer_to_list(?PORT) ++ "\r\n" 
                       || F <- Filenames]),
      gen_tcp:send(Socket, list_to_binary(ResponseAsString ++ ".\r\n"));
    {error, enotdir} -> serve_file(Socket, Path)
  end.

check_item_type(FullPath) ->
  {ok, FileInfo} = file:read_file_info(FullPath),
  case FileInfo#file_info.type of
    regular -> "0";
    directory -> "1"
  end.

serve_file(Socket, Path) -> 
  {ok, BinaryContents} = file:read_file(Path),
  gen_tcp:send(Socket, BinaryContents).


