%%Projekt z pwir
%%W czasie robienia korzysta�em z:
%% http://home.agh.edu.pl/~ptm/doku.php
%% http://blog.bot.co.za/en/article/349/an-erlang-otp-tutorial-for-beginners#.UuQznBCtbIU

-module(graSerw).
-behaviour(gen_server).

%% Serwer 

-export([odpalamy/0,wezly_start/2]).
-export([init/1,handle_call/3,handle_cast/2,handle_info/2]).
-export([stop/0]).
-export([terminate/2]).
-export([generuj_plansze/1,pokaz_stan/0,wczytaj_mi_plansze/1,zapisz_mi_plansze/1,next/0,wyswietlPlansze/0]).
-record(stanS, {pidy,tablica,nr,indeksOst,time}).

%------------------------------------------------

odpalamy() ->
	gen_server:start_link({local,graSerw},graSerw,[],[]).
	
stop() ->
	gen_server:call(graSerw,stop).

generuj_plansze(Roz) ->
	gen_server:call(graSerw,{zrobPlansze,Roz},infinity).
	
pokaz_stan() ->
	gen_server:call(graSerw,pokazStan,infinity).	
	
wczytaj_mi_plansze(Plik) ->
	gen_server:call(graSerw,{wczytajPlansze,Plik},infinity).
	
zapisz_mi_plansze(Plik) ->
	gen_server:cast(graSerw,{zapiszPlansze,Plik},infinity).

next() ->
	gen_server:call(graSerw,liczymy,infinity).

wyswietlPlansze()	->
	gen_server:call(graSerw,wyswietlPlansze,infinity).

wyswietl([H|R])->	
	lists:foreach(fun(X) -> io:format("~w",[X]) end,H),
	io:format("~n"),
	wyswietl(R);
wyswietl([])->io:format("~n",[]).
	
%%rozeslij([],Tab,W,Bl) -> rozeslij(W,Tab,W,Bl);	
%%rozeslij(_,[],_W,_) -> ok;	
%%rozeslij(Pidy,Tab,W,Bl) ->
%%	[A|B]=Pidy,
%%	ATab=lists:sublist(Tab,Bl),
%%	BTab=lists:sublist(Tab,Bl+1,length(Tab)),
%%	A! ATab,
%%	rozeslij(B,BTab,W,Bl).
	
%%Ma rozsy�a� nachodz�ce na siebie kawa�ki tablicy do policzenia podanym pidom
rozeslij2(Lista,Pidy)->	%% zak�adam, �e lista to lista list, a pidy to lista.
	Podzial=trunc(length(Lista)/length(Pidy)),
	rozdzielwew(Lista,Pidy,Podzial,length(Pidy),1).

rozdzielwew(Lista,Pidy,_Podzial,1,Indeks)->
	hd(Pidy) ! {lists:sublist(Lista,Indeks,length(Lista)), Indeks},
	Indeks;
rozdzielwew(Lista,[HPidy|TPidy],Podzial,Zalatwione,Indeks) ->
	HPidy ! {lists:sublist(Lista,Indeks,Podzial+1), Indeks},
	rozdzielwew(Lista,TPidy,Podzial,Zalatwione-1,Indeks+Podzial).

zamienE(Lista,Kawalek,Indeks) -> 
	A=lists:sublist(Lista,Indeks-1), 
	B=lists:sublist(Lista,Indeks+length(Kawalek),length(Lista)), 
	C=A++Kawalek++B,
	C.
%---------------------------------------------

wezly_start(0,W) -> W;
wezly_start(N,W) ->
	P=spawn_link(gra,wezel,[]),
	wezly_start(N-1,lists:append(W,[P])).

init([]) ->
	W=wezly_start(10,[]),
	{ok, #stanS{pidy=W,tablica=[],nr=0,indeksOst=0,time=0}}.
	

terminate(powod,_State) ->
	ok_terminuje_sie.
	
		
handle_call({jestem,_}, _From, State) ->
	Rep="tablica_serwer",
	io:format("tablica_serwer~n",[]),
	{reply,Rep,State};


handle_call({wczytajPlansze,Nazwa},_From,State) ->
	Tab=lifeio:wczytajListe(Nazwa),
	Rep='wczytane',
	{reply,Rep,#stanS{pidy=State#stanS.pidy,tablica=Tab,nr=State#stanS.nr,indeksOst=State#stanS.indeksOst,time=State#stanS.time}};

handle_call(wyswietlPlansze,_From,State) ->
		wyswietl(State#stanS.tablica),
		{reply,wyswietlilem,State};

handle_call(liczymy,_From,State) ->
	T1=now(),
	T=State#stanS.tablica,
	P=State#stanS.pidy,
	%%Bl=round(length(T)/length(P)),
	%%rozeslij(P,T,P,Bl), 
	InOst=rozeslij2(T,P),
	{reply,'done',#stanS{pidy=State#stanS.pidy,tablica=State#stanS.tablica,nr=State#stanS.nr,indeksOst=InOst,time=T1}};
	
handle_call(pokazStan,_From,State) ->
	{reply,State,State};
	
handle_call({zrobPlansze,R},_From,State) ->
	Tab=gra:listalist(R),
	Rep='done',
	{reply,Rep,#stanS{pidy=State#stanS.pidy,tablica=Tab,nr=State#stanS.nr,indeksOst=State#stanS.indeksOst,time=State#stanS.time}}.

	
	
	
handle_cast({zapiszPlansze,Nazwa},State) ->
	lifeio:zapiszListe(State#stanS.tablica,Nazwa),
	{noreply, State};
	
handle_cast({oddaj,Kawalek,Indeks}, State) ->
   Tab=State#stanS.tablica,
   if
	Indeks==1 ->
		Nowa=lists:sublist(Kawalek,length(Kawalek)-1)++lists:sublist(Tab,length(Kawalek),length(Tab));
	Indeks==State#stanS.indeksOst ->
		Nowa=lists:sublist(Tab,length(Tab)-length(Kawalek)+1)++tl(Kawalek);
	Indeks>1; Indeks<State#stanS.indeksOst -> %% czyli kawa�ek jest wewn�trz tablicy, nie na brzegu
		Nowa=zamienE(Tab,tl(lists:sublist(Kawalek,length(Kawalek)-1)),Indeks+1)
	end,
	%%io:format("rozmiar tablicy ~p, a indeks to ~p, a maxIndex=~p~n",[length(Nowa),Indeks,State#stanS.indeksOst]),
   if
		State#stanS.nr+1==length(State#stanS.pidy) -> %%czyli mam wszystkie kawalki jednej iteracji
			T2=now(),	
			Td=timer:now_diff(T2, State#stanS.time),
			io:format("Czas obliczen: ~w~n",[Td]),
			io:format("Catch'em all~n"),
			{noreply,#stanS{pidy=State#stanS.pidy,tablica=Nowa,nr=0,indeksOst=0}};
		true -> %% czyli jeszcze nie wszystko si� policzy�o
			{noreply,#stanS{pidy=State#stanS.pidy,tablica=Nowa,nr=State#stanS.nr+1,indeksOst=State#stanS.indeksOst,time=State#stanS.time}}
   end.



handle_info(info, State) ->
    {noreply, State}.
	




