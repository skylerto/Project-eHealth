note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_NEW_PRESCRIPTION
inherit 
	ETF_NEW_PRESCRIPTION_INTERFACE
		redefine new_prescription end
create
	make
feature -- command 
	new_prescription(id: INTEGER ; doctor: INTEGER ; patient: INTEGER)
		require else 
			new_prescription_precond(id, doctor, patient)
    	do
			-- perform some update on the model state
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
    	end

end
