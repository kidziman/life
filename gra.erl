%%Projekt z pwir
%%W czasie robienia korzysta³em z:
%% http://home.agh.edu.pl/~ptm/doku.php
%% http://blog.bot.co.za/en/article/349/an-erlang-otp-tutorial-for-beginners#.UuQznBCtbIU

-module(gra).
-export([iter/3,licz/0,sasiedzi/3,konw/1,pokaz/3,generujTab/1,loop_iter/3,wezel/1]).

%%
%% Autorzy projektu (dopisaæ tutaj):
%% 



%%generuje losow¹ planszê

generujTab(L) ->
	[random:uniform(2)+47 || _ <- lists:seq(1,round(math:pow(2,L))*round(math:pow(2,L)))].

	
%% oblicza now¹ tablicê - napis , L - stara tablica - napis,
%% Length - d³ugoœæ wiersza tablicy, C - aktualny indeks ( zaczyna siê od najwiekszego)

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
%% porzucone :(
%%Zwraca iloœæ s¹siadów punktu o indeksie I, przy d³ugoœci wiersza tablicy W, wysokosci kolumny - H,numer kolumny - C, ilsoc kolumn -mC M - ca³a tablica - napis
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
%Pokazuje tablicê, D - napis, L - d³ugoœæ wiersza, LL - aktualna linijka

pokaz(D,L,LL) ->
	if L*L==LL-1 -> io:format("~n",[]);
		true -> 
			P=string:sub_string(D,LL,LL+L-1),
			io:format("~s~n",[P]),
			pokaz(D,L,LL+L)
	end.
	
%Wykonuje podan¹ iloœæ iteracji L po tablicy T, o rozmiarze S
	
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
	gen_server:cast(graSerw,{self(),iter(W,8,64)}),
	wezel(N-1).

%%do eksporta do³o¿yæ krotkakrotek/1, listalist/1, getNeighbors/3

%%ma zwracaæ listê list wype³nionych 0/1 o podanym rozmiarze, nie wiem, czy siê przyda	
listalist(R)->
	feedData([],R,R).
	
feedData(Lista,0,_Len)-> Lista;
feedData(Lista,Count,Len) ->
		Data = [random:uniform(2)-1 || _ <- lists:seq(1, Len)],
		feedData([Data|Lista],Count-1,Len).

%%ma zwracaæ krotkê krotek wype³nionych 0/1 o podanym rozmiarze, nie wiem, czy siê przyda	
krotkakrotek(R)->
	feedData2([],R,R).
	
feedData2(L,0,_Len)-> list_to_tuple(L);
feedData2(L,Count,Len) ->
		Data = list_to_tuple([random:uniform(2)-1 || _ <- lists:seq(1, Len)]),
		feedData2([Data|L],Count-1,Len).
		
%%ilosc ¿ywych s¹siadów dla komórki (X,Y) w krotcekrotek K
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


