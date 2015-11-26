note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_INTERACTION
inherit 
	ETF_ADD_INTERACTION_INTERFACE
		redefine add_interaction end
create
	make
feature -- command 
	add_interaction(id1: INTEGER ; id2: INTEGER)
		require else 
			add_interaction_precond(id1, id2)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
