note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_NEW_PRESCRIPTION_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent new_prescription(? , ? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER} etf_cmd_args[1] as id and then attached {INTEGER} etf_cmd_args[2] as doctor and then attached {INTEGER} etf_cmd_args[3] as patient
			then
				out := "new_prescription(" + etf_event_argument_out("new_prescription", "id", id) + "," + etf_event_argument_out("new_prescription", "doctor", doctor) + "," + etf_event_argument_out("new_prescription", "patient", patient) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	new_prescription_precond(id: INTEGER ; doctor: INTEGER ; patient: INTEGER): BOOLEAN
		do  
			Result := 
				         comment ("ID_RX = INTEGER")
				and then comment ("ID_MD = INTEGER")
				and then comment ("ID_PT = INTEGER")
		ensure then  
			Result = 
				         comment ("ID_RX = INTEGER")
				and then comment ("ID_MD = INTEGER")
				and then comment ("ID_PT = INTEGER")
		end 
feature -- command 
	new_prescription(id: INTEGER ; doctor: INTEGER ; patient: INTEGER)
		require 
			new_prescription_precond(id, doctor, patient)
    	deferred
    	end
end
