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
        if id1 <= 0 or id2 <= 0 then
          -- ERROR:     medication ids must be positive integers
        elseif id1 = id2 then
          -- ERROR:     medication ids must be different
        elseif false then
          -- ERROR:     medications with these ids must be registered
        elseif false then
          -- ERROR:     interaction already exists
        elseif false then
          --ERROR:     first remove conflicting medicine prescribed by generalist
        else
			-- perform some update on the model state
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])
        end
    	end

end
