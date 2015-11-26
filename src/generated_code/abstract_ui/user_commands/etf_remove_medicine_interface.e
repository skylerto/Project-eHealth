note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ETF_REMOVE_MEDICINE_INTERFACE
inherit
	ETF_COMMAND
		redefine 
			make 
		end

feature {NONE} -- Initialization

	make(an_etf_cmd_name: STRING; etf_cmd_args: TUPLE; an_etf_cmd_container: ETF_ABSTRACT_UI_INTERFACE)
		do
			Precursor(an_etf_cmd_name,etf_cmd_args,an_etf_cmd_container)
			etf_cmd_routine := agent remove_medicine(? , ?)
			etf_cmd_routine.set_operands (etf_cmd_args)
			if
				attached {INTEGER} etf_cmd_args[1] as id and then attached {INTEGER} etf_cmd_args[2] as medicine
			then
				out := "remove_medicine(" + etf_event_argument_out("remove_medicine", "id", id) + "," + etf_event_argument_out("remove_medicine", "medicine", medicine) + ")"
			else
				etf_cmd_error := True
			end
		end

feature -- command precondition 
	remove_medicine_precond(id: INTEGER ; medicine: INTEGER): BOOLEAN
		do  
			Result := 
				         comment ("ID_RX = INTEGER")
				and then comment ("ID_MN = INTEGER")
		ensure then  
			Result = 
				         comment ("ID_RX = INTEGER")
				and then comment ("ID_MN = INTEGER")
		end 
feature -- command 
	remove_medicine(id: INTEGER ; medicine: INTEGER)
		require 
			remove_medicine_precond(id, medicine)
    	deferred
    	end
end
