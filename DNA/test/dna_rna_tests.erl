-module(dna_rna_tests).

-include_lib("eunit/include/eunit.hrl").

-export([setup/0, teardown/1]).

count_test_() ->
    {foreach,
        fun setup/0,
        fun teardown/1,
        [
            fun rna_transform_test_/1
        ]}.

setup() ->
    application:start(rosalind).

teardown(_Args) ->
    application:stop(rosalind).

rna_transform_test_(_args) ->
    {ok, Pid} = rosalind_sup:rna(),
    [?_assertEqual("GAUGGAACUUGACUACGUAAAUU", dna_rna:rna_from_dna(Pid,
                "GATGGAACTTGACTACGTAAATT"))].
