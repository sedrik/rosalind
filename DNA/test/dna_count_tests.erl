-module(dna_count_tests).

-include_lib("eunit/include/eunit.hrl").

-export([setup/0, teardown/1]).

count_test_() ->
    {foreach,
        fun setup/0,
        fun teardown/1,
        [
            fun count_a_test_/1,
            fun simple_count_test_/1,
            fun count_test_/1
        ]}.

setup() ->
    application:start(rosalind).

teardown(_Args) ->
    application:stop(rosalind).

count_a_test_(_Args) ->
    {ok, Pid} = rosalind_sup:dna_counter(),
    dna_count:count(Pid, "A"),
    [?_assertEqual({1,0,0,0}, dna_count:get_count(Pid))].

simple_count_test_(_args) ->
    {ok, Pid} = rosalind_sup:dna_counter(),
    dna_count:count(Pid, "ACGT"),
    [?_assertEqual({1,1,1,1}, dna_count:get_count(Pid))].

count_test_(_args) ->
    {ok, Pid} = rosalind_sup:dna_counter(),
    dna_count:count(Pid,
        "AGCTTTTCATTCTGACTGCAACGGGCAATATGTCTCTGTGTGGATTAAAAAAAGAGTGTCTGATAGCAGC"),
    [?_assertEqual({20,12,17,21}, dna_count:get_count(Pid))].
