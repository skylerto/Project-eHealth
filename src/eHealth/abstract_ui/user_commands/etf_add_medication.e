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
        if id <= 0 then
          -- ERROR: medication id must be a positive integer
        elseif false then
          -- ERROR: medication id already in use
        elseif false then
          -- ERROR: medication name must start with a letter
        elseif false then
          -- ERROR: medication name already in use
        elseif medicine.low > medicine.hi or medicine.low < 0.0 then
          -- ERROR: require 0 < low-dose <= hi-dose
        else
			-- perform some update on the model state
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])
        end
    	end

end
