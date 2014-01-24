%%Projekt z pwir

-module(graSuper).
-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(CHILD(Id, Mod, Type, Args), {Id, {Mod, odpalamy, Args},
                                     permanent, 5000, Type, [Mod]}).

%API fkcje

start_link() ->
	supervisor:start_link({local, graSuper},graSuper,[]).
	
	
	
%--------------------------

init([]) ->
	{ok,{{one_for_all,10,10},[?CHILD(graSerw, graSerw, worker,[])]}}.

	
