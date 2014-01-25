%%Projekt z pwir
%%W czasie robienia korzysta³em z:
%% http://home.agh.edu.pl/~ptm/doku.php
%% http://blog.bot.co.za/en/article/349/an-erlang-otp-tutorial-for-beginners#.UuQznBCtbIU

-module(graSerw).
-behaviour(gen_server).

%% Serwer 

-export([odpalamy/0,wezly_start/2]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2]).
-export([stop/0]).
-export([terminate/2]).

-record(state, {}).

%------------------------------------------------

odpalamy() ->
	gen_server:start_link({local,graSerw},graSerw,[],[]).
	
stop() ->
	gen_server:call(graSerw,stop).


	
%---------------------------------------------

wezly_start(0,W) -> W;
wezly_start(N,W) ->
	P=spawn_link(gra,wezel,[1]),
	wezly_start(N-1,[W|P]).

init([]) ->
	wezly_start(10,[]),
	{ok, #state{}}.
	

terminate(powod,State) ->
	ok.
	
		
handle_call({jestem,_}, _From, State) ->
	Rep="1101111111111101",
	io:format("1101111111111101~n",[]),
	{reply,Rep,State}.
	
handle_cast({_,L}, State) ->
   io:format("~s~n",[L]),
  {noreply,State}.


handle_info(info, State) ->
    {noreply, State}.
	

	

