note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_PATIENT
inherit
	ETF_ADD_PATIENT_INTERFACE
		redefine add_patient end
create
	make
feature -- command
	add_patient(id: INTEGER ; name: STRING)
		require else
			add_patient_precond(id, name)
    	do
	        if id <= 0 then
	          -- ERROR:     patient id must be a positive integer
	        elseif false then
	          -- ERROR:     patient id already in use
	        elseif false then
	          -- ERROR:    name must start with a letter
	        else
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])
	        end
    	end

end
