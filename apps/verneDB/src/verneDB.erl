-module(verneDB).

-export([add_subscriber/2,read_subscriber/0]).

-include("../include/verneDB.hrl").

add_subscriber(SubacriberId,Topic)->
	Rec = #vmq_trie_subs{subscriberId = SubacriberId,topic = Topic },
	case mnesia:dirty_write(vmq_trie_subs,Rec) of
		ok ->
			{ok,updated};
		Res ->
			{error,Res}
	end.
		
traverse_table_and_show(Table_name)->
    Iterator =  fun(Rec,_)->
                    io:format("~p~n",[Rec]),
                    []
                end,
    case mnesia:is_transaction() of
        true -> mnesia:foldl(Iterator,[],Table_name);
        false -> 
            Exec = fun({Fun,Tab}) -> mnesia:foldl(Fun, [],Tab) end,
            mnesia:activity(transaction,Exec,[{Iterator,Table_name}],mnesia_frag)
    end.
	
read_subscriber() ->
	traverse_table_and_show(vmq_trie_subs).
