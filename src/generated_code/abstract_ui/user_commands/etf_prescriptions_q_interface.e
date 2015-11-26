note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_PRESCRIPTIONS_Q_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent prescriptions_q(?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER} etf_cmd_args[1] as medication_id
			then
				out := "prescriptions_q(" + etf_event_argument_out("prescriptions_q", "medication_id", medication_id) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	prescriptions_q_precond(medication_id: INTEGER): BOOLEAN
		do  
			Result := 
				comment ("ID_MN = INTEGER")
		ensure then  
			Result = 
				comment ("ID_MN = INTEGER")
		end 
feature -- command 
	prescriptions_q(medication_id: INTEGER)
		require 
			prescriptions_q_precond(medication_id)
    	deferred
    	end
end
