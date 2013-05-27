-module(rosalind_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, dna/1, dna_counter/0, rna/0, dna_to_rna/1]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

dna_counter() ->
    dna_count:start_link().

rna() ->
    dna_rna:start_link().

dna(String) ->
    {ok, Pid} = dna_count:start_link(),
    dna_count:count(Pid, String),
    {A, C, G, T} = dna_count:get_count(Pid),
    io:format("~p ~p ~p ~p", [A, C, G, T]).

dna_to_rna(DNA) ->
    {ok, Pid} = dna_rna:start_link(),
    RNA = dna_rna:rna_from_dna(Pid, DNA),
    io:format("~p", [RNA]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
    {ok, { {one_for_one, 5, 10}, []} }.

