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
		local
			m : STATUS_MESSAGE
		do
			if id < 1 then
				create m.make_presc_id_pos
			elseif not model.prescription_id_used (id) then
				create m.make_presc_not_exists
			elseif medicine < 1 then
				create m.make_med_id_pos
			elseif not model.medication_exists (medicine) then
				create m.make_med_not_reg
			elseif not model.medicine_prescribed (id, medicine) then
				create m.make_med_not_in_presc
			else
				create m.make_ok
				model.remove_medicine(id, medicine)
			end
			model.default_update
			model.set_message(m)
			etf_cmd_container.on_change.notify ([Current])
		end
end
