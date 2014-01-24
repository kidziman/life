%%Projekt z pwir

-module(gra).
-export([iter/3,licz/0,sasiedzi/3,konw/1,pokaz/3,generujTab/1,loop_iter/3,wezel/1]).

%%
%% Autorzy projektu (dopisa� tutaj):
%% 





%%generuje losow� plansz�

generujTab(L) ->
	[random:uniform(2)+47 || _ <- lists:seq(1,round(math:pow(2,L))*round(math:pow(2,L)))].

	
%% oblicza now� tablic� - napis , L - stara tablica - napis,
%% Length - d�ugo�� wiersza tablicy, C - aktualny indeks ( zaczyna si� od najwiekszego)

iter(_,_,0) -> [];
iter(L,Length,C) ->
	S=gra:sasiedzi(L,C,Length),
	E=string:sub_string(L,C,C),
	if
		E=="1" ->
				if
					S==2 -> iter(L,Length,C-1)++"1";
					S==3 -> iter(L,Length,C-1)++"1";
					S<2  -> iter(L,Length,C-1)++"0";
					S>3  -> iter(L,Length,C-1)++"0"
				end;
		E=="0" ->
				if
					S==3 -> iter(L,Length,C-1)++"1";
					S<3  -> iter(L,Length,C-1)++"0";
					S>3  -> iter(L,Length,C-1)++"0"
				end
	end.

%%Konwertuje napis na list� cyfr

konw([]) -> [];
konw([H|L]) ->
	[H-48]++konw(L).
	
%%Zwraca ilo�� s�siad�w punktu o indeksie I, przy d�ugo�ci wiersza tablicy L, M - ca�a tablica - napis

sasiedzi(M,I,L) ->
	if
		I<L ; I rem L == 0 ; I rem L == 1 ; I> L*(L-1) -> 0;
		true -> A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+1,I+1)++
	string:sub_string(M,I-L,I-L)++string:sub_string(M,I+L,I+L)++string:sub_string(M,I-L-1,I-L-1)++string:sub_string(M,I-L+1,I-L+1)++
	string:sub_string(M,I+L+1,I+L+1)++string:sub_string(M,I+L-1,I+L-1),
	%% io:format("~s~n",[A]),
	lists:sum(konw(A))
	end.


%Pokazuje tablic�, D - napis, L - d�ugo�� wiersza, LL - aktualna linijka

pokaz(D,L,LL) ->
	if L*L==LL-1 -> io:format("~n",[]);
		true -> 
			P=string:sub_string(D,LL,LL+L-1),
			io:format("~s~n",[P]),
			pokaz(D,L,LL+L)
	end.
	
%Wykonuje podan� ilo�� iteracji L po tablicy T, o rozmiarze S
	
loop_iter(T,0,S) -> gra:pokaz(T,round(math:sqrt(S)),1);
loop_iter(T,L,S) ->
	W=gra:iter(T,round(math:sqrt(S)),S),
	gra:pokaz(T,round(math:sqrt(S)),1),
	loop_iter(W,L-1,S).

%% 
licz() ->
	%%lifeio:testWrite(8),
	%%{D,_}=lifeio:lifeRead("fff.gz"),
	%%{T}=lifeio:readData(D,256),
	
	T=gra:generujTab(6),
    loop_iter(T,20,64*64).

	%%file:close(D).
	

%%-----------------------------------------------------------------------------------------------------------------------------
%% 

%% funkcja 'kliencka' do spawn
	
wezel(0) -> ok;
wezel(N) ->
	io:format("gotowy!~n"),
	W=gen_server:call(graSerw,{jestem,self()}),
	gen_server:cast(graSerw,{self(),iter(W,4,16)}),
	wezel(N-1).

	


