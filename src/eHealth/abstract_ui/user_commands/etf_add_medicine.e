note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_MEDICINE
inherit 
	ETF_ADD_MEDICINE_INTERFACE
		redefine add_medicine end
create
	make
feature -- command 
	add_medicine(id: INTEGER ; medicine: INTEGER ; dose: VALUE)
		require else 
			add_medicine_precond(id, medicine, dose)
    	do
        if id <= 0 then
          -- ERROR:     prescription id must be a positive integer
        elseif false then
          -- ERROR:     prescription with this id does not exist
        elseif medicine <= 0 then
          -- ERROR:     medication id must be a positive integer
        elseif false then
          -- ERROR:     medication id must be registered
        elseif false then
          -- ERROR:     medication is already prescribed
        elseif false then
          -- ERROR:     specialist is required to add a dangerous interaction
        elseif false then
          -- ERROR:     dose is outside allowed range
        else
		      	-- perform some update on the model state
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])
        end
    	end

end
