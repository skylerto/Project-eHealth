note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_REMOVE_MEDICINE
inherit 
	ETF_REMOVE_MEDICINE_INTERFACE
		redefine remove_medicine end
create
	make
feature -- command 
	remove_medicine(id: INTEGER ; medicine: INTEGER)
		require else 
			remove_medicine_precond(id, medicine)
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
          -- ERRORL     medication is not in the prescription
        else
		      	-- perform some update on the model state
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])
    	  end
    	end
end
