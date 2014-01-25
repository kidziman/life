%%Projekt z pwir
%%W czasie robienia korzysta³em z:
%% http://home.agh.edu.pl/~ptm/doku.php
%% http://blog.bot.co.za/en/article/349/an-erlang-otp-tutorial-for-beginners#.UuQznBCtbIU

-module(graSuper).
-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

% tu podobnie jak w sup.erl ze strony lab
-define(CHILD(Id, Mod, Type, Args), {Id, {Mod, odpalamy, Args},
                                     permanent, 5000, Type, [Mod]}).

%API fkcje

start_link() ->
	supervisor:start_link({global, graSuper},graSuper,[]).
	
	
	
%--------------------------

init([]) ->
	{ok,{{one_for_all,10,10},[?CHILD(graSerw, graSerw, worker,[])]}}.

	
