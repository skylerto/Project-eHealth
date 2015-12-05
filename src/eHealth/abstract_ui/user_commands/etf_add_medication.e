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
			local
				m : STATUS_MESSAGE
			do
				if id < 1 then
					create m.make_med_id_pos
				elseif model.medications.medication_exists (id) then
					create m.make_med_id_in_use
				elseif not model.is_valid_string (medicine.name) then
					create m.make_med_name_start
				elseif model.medications.medication_name_used (medicine.name) then
					create m.make_med_name_in_use
				elseif not((0 < medicine.low.as_double) and (medicine.low <= medicine.hi)) then
					create m.make_valid_range
				else
					create m.make_ok
					model.add_medication (id, medicine)
				end
				model.default_update
				model.set_message(m)
				etf_cmd_container.on_change.notify ([Current])
			end

end
