-module(gra).
-export([iter/3,licz/0,sasiedzi/3,konw/1,pokaz/3,generujTab/1]).

%%
%% Autorzy projektu (dopisaæ tutaj):
%% 


%% oblicza now¹ tablicê - napis , L - stara tablica - napis,
%% Length - d³ugoœæ wiersza tablicy, C - aktualny indeks ( zaczyna siê od najwiekszego)

%%generuje losow¹ planszê
generujTab(L) ->
	[random:uniform(2)+47 || _ <- lists:seq(1,round(math:pow(2,L))*round(math:pow(2,L)))].

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

%%Konwertuje napis na listê cyfr

konw([]) -> [];
konw([H|L]) ->
	[H-48]++konw(L).
	
%%Zwraca iloœæ s¹siadów punktu o indeksie I, przy d³ugoœci wiersza tablicy L, M - ca³a tablica - napis

sasiedzi(M,I,L) ->
	if
		I<L ; I rem L == 0 ; I rem L == 1 ; I> L*(L-1) -> 0;
		true -> A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+1,I+1)++
	string:sub_string(M,I-L,I-L)++string:sub_string(M,I+L,I+L)++string:sub_string(M,I-L-1,I-L-1)++string:sub_string(M,I-L+1,I-L+1)++
	string:sub_string(M,I+L+1,I+L+1)++string:sub_string(M,I+L-1,I+L-1),
	%% io:format("~s~n",[A]),
	lists:sum(konw(A))
	end.


%Pokazuje tablicê, D - napis, L - d³ugoœæ wiersza, LL - aktualna linijka

pokaz(D,L,LL) ->
	if L*L==LL-1 -> io:format("~n",[]);
		true -> 
			P=string:sub_string(D,LL,LL+L-1),
			io:format("~s~n",[P]),
			pokaz(D,L,LL+L)
	end.
	
%% 
	
licz() ->
	%%lifeio:testWrite(8),
	%%{D,_}=lifeio:lifeRead("fff.gz"),
	%%{T}=lifeio:readData(D,256),
	
	T=gra:generujTab(4),
	gra:pokaz(T,16,1),
	W=gra:iter(T,16,256),
	gra:pokaz(gra:iter(W,16,256),16,1),
	gra:pokaz(gra:iter(gra:iter(W,16,256),16,256),16,1).

	%%file:close(D).
	
	