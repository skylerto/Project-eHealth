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
			local
				m : STATUS_MESSAGE
			do
				if id < 1 then
					create m.make_patient_id_pos
				elseif model.patients.patient_exists (id) then
					create m.make_patient_id_in_use
				elseif not model.is_valid_string (name) then
					create m.make_name_start
				else
					create m.make_ok
					model.add_patient (id, name)
				end
				model.set_message(m)
				etf_cmd_container.on_change.notify ([Current])
			end

end
