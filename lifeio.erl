-module(lifeio).
-export([zapiszWiersz/3,wczytajListe/1,zapiszListe/2,lifeRead/1,readData/2,lifeWrite/2,writeData/2,testWrite/1,zapisz/3]).

%% modyfikowany kod ze strony z laboratorium 


%% procedura testowa zapisująca losową plansze
%% o wskazanym rozmiarze
testWrite(Size) ->
		Len = trunc(math:pow(2,Size)),
		{ok,FD} = lifeWrite('aktualna.gz',Size),
		file:write(FD,[Size]),
		feedData(FD,Len,Len),
		file:close(FD).

feedData(_FD,0,_Len)-> ok;
feedData(FD,Count,Len) ->
		Data = [random:uniform(2)+48-1 || _ <- lists:seq(1, Len)],
		writeData(FD,Data),
		feedData(FD,Count-1,Len).

	
%zapisuje planszę Data o rozmiarze - wykładnik potęgi 2 , do pliku o sciezce SC
	
zapisz(SC,Data,SIZE)  ->
	{ok,FD}=lifeWrite(SC,SIZE),
	file:write(FD,[SIZE]),
	file:write(FD,Data),
	file:close(FD).
	
%%-------------------------------------------------------------------------	
%% procedura testowa odczytująca planszę z pliku
wczytajListe(FileName) ->
		{FD,Size} = lifeRead(FileName),
		Len = trunc(math:pow(2,Size)),
		io:fwrite("Rozmiar ~B, Plansza ~Bx~B~n",[Size,Len,Len]),
		Lista=getData(FD,Len,Len,[]),
		file:close(FD),
		lists:reverse(Lista).

%% otwarcie pliku do wczytywania
%% zwracany jest deskryptor pliku i rozmiar danych/planszy
lifeRead(FileName) ->
		{ok,FD} = file:open(FileName,[read,compressed]),
		case file:read(FD,1) of 
				{ok,[Data]} -> {FD,Data};
				eof -> io:format("~nKoniec~n",[]);
				{error,Reason} -> io:format("~s~n",[Reason])
		end.

getData(_FD,_Len,0,Lista) -> Lista;
getData(FD,Len,Count,Lista) ->
		Wiersz=readData(FD,Len),
		getData(FD,Len,Count-1,[Wiersz|Lista]).

readData(FD,Length) -> 
		case file:read(FD,Length) of 
				{ok,Data} -> [X-48 || X <- Data];
				eof -> io:format("~nKoniec~n",[]);
				{error,Reason} -> io:format("~s~n",[Reason])
		end.

%%zapis lilstylist do pliku, zakładam,że kwadratowa,
%%zapisuje zera i jedynki, jak leci, nie dodając 48.
zapiszListe(Lista,Nazwapliku) ->
		Len =length(Lista),
		Size=trunc(math:log(Len) / math:log(2)),%magia
		{ok,FD} = lifeWrite(Nazwapliku,Size), %Size to jest wykładnik, np 10 dla tablicy 1024x1024
		file:write(FD,[Size]),
		zapiszWiersz(FD,Len,Lista),
		file:close(FD).
		
zapiszWiersz(_FD,0,_Lista)-> ok;
zapiszWiersz(FD,Count,[H|T]) ->
		writeData(FD,[N+48 || N <- H]),
		zapiszWiersz(FD,Count-1,T).
		
%% otwarcie pliku do zapisu planszy o wskazanym rozmiarze
lifeWrite(FileName,Size)->
		{ok,FD} = file:open(FileName,[write,compressed]),
		file:write(FD,Size),
		{ok,FD}.

%% zapisanie kolejnej porcji danych
writeData(FD,Data) ->
		file:write(FD,Data).