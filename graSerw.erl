%%Projekt z pwir

-module(graSerw).
-behaviour(gen_server).

%% Serwer 

-export([odpalamy/0,wezly_start/2]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2]).
-export([stop/0]).
-export([terminate/2]).

-record(state, {count}).

%------------------------------------------------

odpalamy() ->
	gen_server:start_link({local,graSerw},graSerw,[],[]).
	
stop() ->
	gen_server:cast(graSerw,stop).


	
%---------------------------------------------

wezly_start(0,W) -> W;
wezly_start(N,W) ->
	P=spawn_link(gra,wezel,[1]),
	wezly_start(N-1,[W|P]).

init([]) ->
	wezly_start(10,[]),
	{ok, #state{count=0}}.
	

terminate(normal,State) ->
	error_logger:info_msg("konczenie~n"),
	ok.
	
		
handle_call({jestem,_}, _From, State) ->
	Rep="1101111111111101",
	io:format("1101111111111101~n",[]),
	{reply,Rep,State}.
	
handle_cast({_,L}, State) ->
   io:format("~s~n",[L]),
  {noreply,State};
	
handle_cast(stop,State) ->
	{stop,normal,State}.
	
handle_info(Info, State) ->      % handle_info deals with out-of-band msgs, ie
    error_logger:info_msg("~p~n", [Info]), % msgs that weren't sent via cast
    {noreply, State}.          % or call. Here we simply log such messages.
	

	

