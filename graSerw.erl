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
-export([rozeslij2/2,generuj_plansze/1,pokaz_stan/0,wczytaj_mi_plansze/1,zapisz_mi_plansze/1,chlopaki_liczymy/0,rozeslij/4]).
-record(stanS, {pidy,tablica,nr,indeksOst}).

%------------------------------------------------

odpalamy() ->
	gen_server:start_link({local,graSerw},graSerw,[],[]).
	
stop() ->
	gen_server:call(graSerw,stop).

generuj_plansze(Roz) ->
	gen_server:call(graSerw,{zrobPlansze,Roz}).
	
pokaz_stan() ->
	gen_server:call(graSerw,pokazStan).	
	
wczytaj_mi_plansze(Plik) ->
	gen_server:call(graSerw,{wczytajPlansze,Plik}).
	
zapisz_mi_plansze(Plik) ->
	gen_server:cast(graSerw,{zapiszPlansze,Plik}).

chlopaki_liczymy() ->
	gen_server:call(graSerw,liczymy).
	
rozeslij([],Tab,W,Bl) -> rozeslij(W,Tab,W,Bl);	
rozeslij(_,[],_W,_) -> ok;	
rozeslij(Pidy,Tab,W,Bl) ->
	[A|B]=Pidy,
	ATab=lists:sublist(Tab,Bl),
	BTab=lists:sublist(Tab,Bl+1,length(Tab)),
	A! ATab,
	rozeslij(B,BTab,W,Bl).
	
%%Ma rozsy³aæ nachodz¹ce na siebie kawa³ki tablicy do policzenia podanym pidom
rozeslij2(Lista,Pidy)->	%% zak³adam, ¿e lista to lista list, a pidy to lista.
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
	B=tl(lists:sublist(Lista,Indeks,length(Lista))), 
	C=A++[Kawalek]++B,
	C.
%---------------------------------------------

wezly_start(0,W) -> W;
wezly_start(N,W) ->
	P=spawn_link(gra,wezel,[]),
	wezly_start(N-1,lists:append(W,[P])).

init([]) ->
	W=wezly_start(10,[]),
	{ok, #stanS{pidy=W,tablica=[],nr=0,indeksOst=0}}.
	

terminate(powod,_State) ->
	ok_terminuje_sie.
	
		
handle_call({jestem,_}, _From, State) ->
	Rep="tablica_serwer",
	io:format("tablica_serwer~n",[]),
	{reply,Rep,State};


handle_call({wczytajPlansze,Nazwa},_From,State) ->
	Tab=lifeio:wczytajListe(Nazwa),
	Rep='wczytane',
	{reply,Rep,#stanS{pidy=State#stanS.pidy,tablica=Tab,nr=State#stanS.nr,indeksOst=State#stanS.indeksOst}};

handle_call(liczymy,_From,State) ->
	T=State#stanS.tablica,
	P=State#stanS.pidy,
	%%Bl=round(length(T)/length(P)),
	%%rozeslij(P,T,P,Bl), 
	InOst=rozeslij2(T,P),
	{reply,'done',#stanS{pidy=State#stanS.pidy,tablica=State#stanS.tablica,nr=State#stanS.nr,indeksOst=InOst}};
	
handle_call(pokazStan,_From,State) ->
	{reply,State,State};
	
handle_call({zrobPlansze,R},_From,State) ->
	Tab=gra:listalist(R),
	Rep='done',
	{reply,Rep,#stanS{pidy=State#stanS.pidy,tablica=Tab,nr=State#stanS.nr,indeksOst=State#stanS.indeksOst}}.

	
	
	
handle_cast({zapiszPlansze,Nazwa},State) ->
	lifeio:zapiszListe(State#stanS.tablica,Nazwa),
	{noreply, State};
	
handle_cast({oddaj,Kawalek,Indeks}, State) ->
   io:format("Dosta³em kawalek~n"),
   Tab=State#stanS.tablica,
   if
	Indeks==1 ->
		Nowa=zamienE(Tab,Kawalek,Indeks);
	Indeks==State#stanS.indeksOst ->
		Nowa=zamienE(Tab,tl(Kawalek),Indeks+1);
	true -> %% czyli kawa³ek jest wewn¹trz tablicy, nie na brzegu
		Nowa=zamienE(Tab,tl(lists:sublist(Kawalek,length(Kawalek)-1)),Indeks+1)
	end,
   if
		State#stanS.nr+1==length(State#stanS.pidy) -> %%czyli mam wszystkie kawalki jednej iteracji
			io:format("Catch'em all~n"),
			{noreply,#stanS{pidy=State#stanS.pidy,tablica=Nowa,nr=State#stanS.nr+1,indeksOst=State#stanS.indeksOst}};	
		true -> %% czyli jeszcze nie wszystko siê policzy³o
			{noreply,#stanS{pidy=State#stanS.pidy,tablica=Nowa,nr=0,indeksOst=0}}
   end.



handle_info(info, State) ->
    {noreply, State}.
	




