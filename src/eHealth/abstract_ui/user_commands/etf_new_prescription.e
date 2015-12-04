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
        if id <= 0 then
          -- ERROR:     prescription id must be a positive integer
        elseif false then
          -- ERROR:     prescription id already in use
        elseif doctor <= 0 then
          --ERROR:    physician id must be a positive integer
         elseif false then
          -- ERROR:    physician with this id not registered
         elseif patient <= 0 then
           -- ERROR:     patient id must be a positive integer
         elseif false then
          -- ERROR:     patient with this id not registered
        elseif false then
          -- ERROR:     prescription already exists for this physican and patient
        else
			    -- perform some update on the model state
			    model.default_update
			    etf_cmd_container.on_change.notify ([Current])

    	  end
    	end

end
