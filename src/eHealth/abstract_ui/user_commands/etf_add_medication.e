note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_MEDICATION
inherit 
	ETF_ADD_MEDICATION_INTERFACE
		redefine add_medication end
create
	make
feature -- command 
	add_medication(id: INTEGER ; medicine: TUPLE[name: STRING; kind: INTEGER; low: VALUE; hi: VALUE])
		require else 
			add_medication_precond(id, medicine)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
