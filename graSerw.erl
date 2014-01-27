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
-export([zrob_mi_plansze/1,pokaz_stan/0,wczytaj_mi_plansze/1,chlopaki_liczymy/0,rozeslij/2]).
-record(stanS, {pidy,tablica}).

%------------------------------------------------

odpalamy() ->
	gen_server:start_link({local,graSerw},graSerw,[],[]).
	
stop() ->
	gen_server:call(graSerw,stop).

zrob_mi_plansze(Roz) ->
	gen_server:call(graSerw,{zrobPlansze,Roz}).
	
pokaz_stan() ->
	gen_server:call(graSerw,pokazStan).	
	
wczytaj_mi_plansze(Plik) ->
	gen_server:call(graSerw,{wczytajP,Plik}).

chlopaki_liczymy() ->
	gen_server:call(graSerw,liczymy).

rozeslij([],_) -> ok;	
rozeslij(Pidy,Tab) ->
	[A|B]=Pidy,
	[ATab|BTab]=Tab,
	%A! ATab,
	rozeslij(B,BTab).
%---------------------------------------------

wezly_start(0,W) -> W;
wezly_start(N,W) ->
	P=spawn_link(gra,wezel,[1]),
	wezly_start(N-1,lists:append(W,[P])).

init([]) ->
	W=wezly_start(10,[]),
	{ok, #stanS{pidy=W,tablica=[]}}.
	

terminate(powod,State) ->
	ok.
	
		
handle_call({jestem,_}, _From, State) ->
	Rep="tablica_serwer",
	io:format("tablica_serwer~n",[]),
	{reply,Rep,State};

%Tutaj dorobiæ wczytywanie
handle_call({wczytajP,Pliczek}, _From, State) ->
	Rep='done',
	
	{reply,Rep,State};

handle_call(liczymy,_From,State) ->
	T=State#stanS.tablica,
	P=State#stanS.pidy,
	%rozeslij(P,T), ta fkcja nie dzia³a 
	{reply,'done',State};
	
handle_call(pokazStan,_From,State) ->
	{reply,State,State};
	
handle_call({zrobPlansze,R},_From,State) ->
	Tab=gra:listalist(R),
	Rep='done',
	{reply,Rep,#stanS{pidy=State#stanS.pidy,tablica=Tab}}.
	
handle_cast({_,L}, State) ->
   io:format("~s~n",[L]),
  {noreply,State}.


handle_info(info, State) ->
    {noreply, State}.
	

	

