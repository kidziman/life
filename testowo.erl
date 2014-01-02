-module(testowo).
-export([next/0,test_time/1]).

%%Wykonuje jedn¹ iteracjê po tablicy zapisanej w pliku "aktualna.gz" , po czym zapisuje j¹ spowrotem

next() ->
	%%lifeio:testWrite(4),
	{D,S}=lifeio:lifeRead("aktualna.gz"),
	SIZE=round(math:pow(2,S)),
	{T}=lifeio:readData(D,SIZE*SIZE),
	file:close(D),
	
	W=gra:iter(T,SIZE,SIZE*SIZE),
	
	lifeio:zapisz("aktualna.gz",W,S),
	W.
	
	
%% póki co, wykonuje L iteracji z zapisem i odczytem z pliku, bez pokazania pierwszej planszy

test_time(0) -> ok;
test_time(L) ->
	{D,S}=lifeio:lifeRead("aktualna.gz"),
	SIZE=round(math:pow(2,S)),
	file:close(D),
	
	C=next(),
	gra:pokaz(C,SIZE,1),
	test_time(L-1).