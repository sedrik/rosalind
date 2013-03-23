-module(dna_count).
-behaviour(gen_server).
-define(SERVER, ?MODULE).

-record(state, {a = 0,
                c = 0,
                g = 0,
                t = 0
            }).

%% ------------------------------------------------------------------
%% API Function Exports
%% ------------------------------------------------------------------

-export([start_link/0, count/2, get_count/1, reset/1]).

%% ------------------------------------------------------------------
%% gen_server Function Exports
%% ------------------------------------------------------------------

-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

%% ------------------------------------------------------------------
%% API Function Definitions
%% ------------------------------------------------------------------

start_link() ->
    gen_server:start_link(?MODULE, #state{}, []).

count(Pid, Input) ->
    gen_server:cast(Pid, {count, Input}).

get_count(Pid) ->
    gen_server:call(Pid, get_count).

reset(Pid) ->
    gen_server:cast(Pid, reset).

%% ------------------------------------------------------------------
%% gen_server Function Definitions
%% ------------------------------------------------------------------

init(State) ->
    {ok, State}.

handle_call(get_count, _From, State = #state{a = A, c = C, g = G, t = T}) ->
    {reply, {A, C, G, T}, State};
handle_call(_Request, _From, State) ->
    {reply, ok, State}.

handle_cast(reset, _State) ->
    {noreply, #state{}};
handle_cast({count, In}, State) ->
    NewState = do_count(In, State),
    {noreply, NewState};
handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%% ------------------------------------------------------------------
%% Internal Function Definitions
%% ------------------------------------------------------------------

do_count([], State) ->
    State;
do_count("A" ++ Tail, State = #state{a = A}) ->
    do_count(Tail, State#state{a = A + 1});
do_count("C" ++ Tail, State = #state{c = C}) ->
    do_count(Tail, State#state{c = C + 1});
do_count("G" ++ Tail, State = #state{g = G}) ->
    do_count(Tail, State#state{g = G + 1});
do_count("T" ++ Tail, State = #state{t = T}) ->
    do_count(Tail, State#state{t = T + 1}).
