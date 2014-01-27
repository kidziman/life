%%Projekt z pwir
%%W czasie robienia korzysta�em z:
%% http://home.agh.edu.pl/~ptm/doku.php
%% http://blog.bot.co.za/en/article/349/an-erlang-otp-tutorial-for-beginners#.UuQznBCtbIU

-module(gra).
-export([iter/3,licz/0,sasiedzi/3,konw/1,pokaz/3,generujTab/1,loop_iter/3,wezel/0,krotkakrotek/1, listalist/1, nextLista/1, nextKrotka/1]).

%%
%% Autorzy projektu (dopisa� tutaj):
%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Podej�cie "napisowe"
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%% porzucone :(
%%Zwraca ilo�� s�siad�w punktu o indeksie I, przy d�ugo�ci wiersza tablicy W, wysokosci kolumny - H,numer kolumny - C, ilsoc kolumn -mC M - ca�a tablica - napis
%%malo to wydajne ale uniwersalne
sasiedzi(M,I,W,H,C,mC) ->
	if 
		C==1 ->
			if
				I==1 ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I==H*W-W+1 -> A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I<W ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W-1,I+W-1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I>H*W-W+1 ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I rem W==1 ->A=string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1)++string:sub_string(M,I+1,I+1)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I rem W==0 ->A=string:sub_string(M,I,I), lists:sum(konw(A));
				true -> A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+1,I+1)++
					string:sub_string(M,I-W,I-W)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W+1,I-W+1)++
					string:sub_string(M,I+W+1,I+W+1)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A))
			end;		
		C==mC ->
			if
				I==W ->A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A));
				I==H*W ->A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W-1,I-W-1), lists:sum(konw(A));
				I==H*W-W+1 -> A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I<W ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W-1,I+W-1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I>H*W-W+1 ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I rem W==1 ->A=string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1)++string:sub_string(M,I+1,I+1)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I rem W==0 ->A=string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A));
				true -> A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+1,I+1)++
					string:sub_string(M,I-W,I-W)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W+1,I-W+1)++
					string:sub_string(M,I+W+1,I+W+1)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A))
			end;
		true->
			if
				I==1 ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I==W ->A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A));
				I==H*W ->A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W-1,I-W-1), lists:sum(konw(A));
				I==H*W-W+1 -> A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I<W ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W-1,I+W-1)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I>H*W-W+1 ->A=string:sub_string(M,I+1,I+1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1), lists:sum(konw(A));
				I rem W==1 ->A=string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W+1,I-W+1)++string:sub_string(M,I+1,I+1)++string:sub_string(M,I+W+1,I+W+1), lists:sum(konw(A));
				I rem W==0 ->A=string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W,I-W)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-1,I-1)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A));
				true -> A=string:sub_string(M,I-1,I-1)++string:sub_string(M,I+1,I+1)++
					string:sub_string(M,I-W,I-W)++string:sub_string(M,I+W,I+W)++string:sub_string(M,I-W-1,I-W-1)++string:sub_string(M,I-W+1,I-W+1)++
					string:sub_string(M,I+W+1,I+W+1)++string:sub_string(M,I+W-1,I+W-1), lists:sum(konw(A))
			end	
	end.
%%
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
	
	T=gra:generujTab(10),
    loop_iter(T,1,1024*1024).

	%%file:close(D).
	

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Podej�cie "listowe" (plansza=lista list)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%zwraca list� list wype�nionych 0/1 o podanym rozmiarze,
listalist(R)->
	feedData([],R,R).
	
feedData(Lista,0,_Len)-> Lista;
feedData(Lista,Count,Len) ->
		Data = [random:uniform(2)-1 || _ <- lists:seq(1, Len)],
		feedData([Data|Lista],Count-1,Len).


		
		
%%oblicza NumGen ilosc iteracji dla listy list L, o rozmiarze NrowsXNCols, ale synchronizuj�c po ka�dej iteracji tego nie potrzebujemy
%%iteruj(L, Nrows, Ncols, 0) ->
%%    L;
%%iteruj(L, Nrows, Ncols, Numgen) ->
%%    iteruj(lifeOnce(Ncols, L), Nrows, Ncols, Numgen - 1).

%%oblicza pojedyncz� iteracj� dla listy list L, nie musi by� "kwadratowa"
nextLista(L) ->
    nastLista(lifePad(length(hd(L)), L)).

%%rozszerza list� o zera na brzegach, �eby si� nie bawi� w przypadki
lifePad(Ncols, L) ->
    [lists:duplicate(Ncols + 2, 0) |
        lists:append(lists:map(fun lifePadRow/1, L),
            [lists:duplicate(Ncols + 2, 0)])].

lifePadRow(Row) ->
    [0 | lists:append(Row, [0])].

%%realizuje funkcj� nextLista
nastLista([X,Y,Z|W]) ->
    [nextRow(X, Y, Z) | nastLista([Y,Z|W])];
nastLista(_) ->
    [].

%%oblicza nastepny stan pojedynczego wiersz z listy list
nextRow([A,B,C|X], [D,E,F|Y], [G,H,I|Z]) ->
    [nextCell(A, B, C, D, E, F, G, H, I) | nextRow([B,C|X], [E,F|Y], [H,I|Z])];
nextRow(_, _, _) ->
    [].

%%Oblicza nast�pny stan dla kom�rki E z reszt� s�siad�w
nextCell(A, B, C, D, E, F, G, H, I) ->
    nastCell(E, A+B+C+D+F+G+H+I).

%%realizuje nextCell
nastCell(0, Neigh) when Neigh =:= 3 -> 1;
nastCell(1, Neigh) when Neigh >= 2, Neigh =< 3 -> 1;
nastCell(Self, Neigh) when (Self =:= 0 orelse Self =:= 1), (Neigh >= 0 andalso Neigh =< 8) -> 0.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Podej�cie "krotkowe", pewnie do wywalenia
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%zwraca krotk� krotek wype�nionych 0/1 o podanym rozmiarze, nie wiem, czy si� przyda	
krotkakrotek(R)->
	feedData2([],R,R).
	
feedData2(L,0,_Len)-> list_to_tuple(L);
feedData2(L,Count,Len) ->
		Data = list_to_tuple([random:uniform(2)-1 || _ <- lists:seq(1, Len)]),
		feedData2([Data|L],Count-1,Len).
		
%%ilosc �ywych s�siad�w dla kom�rki (X,Y) w krotcekrotek K
getNeighbors(K,X,Y) ->
	Sz=tuple_size(element(1,K)),
	Wy=tuple_size(K),
		if X==1 ->
			if Y==1 -> element(2,element(1,K))+element(2,element(2,K))+element(1,element(2,K));
				Y<Wy -> element(1,element(Y-1,K))+element(2,element(Y-1,K))+element(2,element(Y,K))+element(2,element(Y+1,K))+element(1,element(Y+1,K));
				true -> element(1,element(Y-1,K))+element(2,element(Y-1,K))+element(2,element(Y,K))
			end;
			X==Sz -> 
			if Y==1 -> element(X-1,element(Y,K))+element(X-1,element(Y+1,K))+element(X,element(Y+1,K));
				Y==Wy -> element(X-1,element(Y,K))+element(X-1,element(Y-1,K))+element(X,element(Y-1,K));
				true -> element(X,element(Y-1,K))+element(X-1,element(Y-1,K))+element(X-1,element(Y,K))+element(X-1,element(Y+1,K))+element(X,element(Y+1,K))
			end;
			true ->
			if Y==1 -> element(X-1,element(Y,K))+element(X-1,element(Y+1,K))+element(X,element(Y+1,K))+element(X+1,element(Y+1,K))+element(X+1,element(Y,K));
				Y==Wy -> element(X-1,element(Y,K))+element(X-1,element(Y-1,K))+element(X,element(Y-1,K))+element(X+1,element(Y-1,K))+element(X+1,element(Y,K));
				true ->	element(X-1,element(Y-1,K))+element(X,element(Y-1,K))+element(X+1,element(Y-1,K))+element(X+1,element(Y,K))+element(X+1,element(Y+1,K))+element(X,element(Y+1,K))+element(X-1,element(Y+1,K))+element(X-1,element(Y,K))
			end
end.

%%zwraca przysz�y stan kom�rki o indeksie (X,Y) w krotce K
nextState(K,X,Y) ->
	Neigh=getNeighbors(K,X,Y),
	if element(X,element(Y,K))==0 ->
		if Neigh==3 -> 1;
			true -> 0
		end;
	true ->
		if Neigh==2; Neigh==3 -> 1;
			true -> 0
		end
	end.

%%zwraca krotk� po iteracji algorytmu gry, schodzi jej to d�ugo
nextKrotka(K) ->
	nastKrotka(1,1,K,K,tuple_size(element(1,K)),tuple_size(K)).

%%wewnetrzna funkcja realizuj�ca nextKrotka
nastKrotka(Sz,Wy,K,W,Sz,Wy)-> 
	setelement(Wy,W,setelement(Sz, element(Wy,W), nextState(K,Sz,Wy)));
nastKrotka(X,Y,K,W,Sz,Wy)->
	Wtym=setelement(Y,W,setelement(X, element(Y,W), nextState(K,X,Y))),
	if X==Sz -> nastKrotka(1,Y+1,K,Wtym,Sz,Wy);
	true -> nastKrotka(X+1,Y,K,Wtym,Sz,Wy)
	end.

%%-----------------------------------------------------------------------------------------------------------------------------
%% 

%% funkcja 'kliencka' do spawn
	

wezel() ->
	io:format("gotowy!~n"),
	receive
		{Tab,Indeks} ->	%% jak dostanie tablice to liczy i oddaje, nie rusza indeksu
			gen_server:cast(graSerw,{oddaj,nextLista(Tab),Indeks})
		end,
	wezel().

