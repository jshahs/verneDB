-module(verneDB).

-export([add_subscriber/2]).

-include("../include/verneDB.hrl").

add_subscriber(SubacriberId,Topic)->
	Rec = #vmq_trie_subs{subscriberId = SubacriberId,topic = Topic },
	case mnesia:dirty_write(vmq_trie_subs,Rec) of
		ok ->
			{ok,updated};
		Res ->
			{error,Res}
	end.
			

