note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_PRESCRIPTIONS_Q
inherit
	ETF_PRESCRIPTIONS_Q_INTERFACE
		redefine prescriptions_q end
create
	make
feature -- command
	prescriptions_q(medication_id: INTEGER)
		require else
			prescriptions_q_precond(medication_id)
    	do
	        if medication_id <= 0 then
	          -- ERROR:     medication id must be a positive integer
	        elseif false then
	          -- ERROR:     medication id must be registered
	        else
		     	model.default_update
		      	etf_cmd_container.on_change.notify ([Current])
	        end
    	end

end
