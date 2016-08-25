-module(trie_sup).
-behaviour(supervisor).
-export([start_link/1,init/1,stop/0]).
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
start_link(X) -> supervisor:start_link({local, ?MODULE}, ?MODULE, [X]).
stop() -> halt().
init([S]) ->
    %S is the size of the data we store in the trie.
    Children = [%{leaf, {db_sup, start_link, [leaf, 32+S]}, permanent, 5000, supervisor, [db_sup]},
		%{stem, {db_sup, start_link, [stem, 596]}, permanent, 5000, supervisor, [db_sup]},
		{leaf, {dump_sup, start_link, [leaf, 32+S]}, permanent, 5000, supervisor, [dump_sup]},
		{stem, {dump_sup, start_link, [stem, 596]}, permanent, 5000, supervisor, [dump_sup]},
		{trie, {trie, start_link, [S]}, permanent, 5000, worker, [trie]}],
    {ok, { {one_for_one, 5, 10}, Children} }.
