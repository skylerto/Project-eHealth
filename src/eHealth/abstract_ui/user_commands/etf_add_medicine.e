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
		local
			m : STATUS_MESSAGE
		do
			if id < 1 then
				create m.make_med_id_pos
			elseif not model.prescriptions.prescription_id_used (id) then
				create m.make_presc_not_exists
			elseif medicine < 1 then
				create m.make_med_id_pos
			elseif not model.medications.medication_exists (medicine) then
				create m.make_med_not_reg
			elseif model.prescriptions.medicine_prescribed(id, medicine) then
				create m.make_med_is_presc
			elseif false then
				create m.make_not_specialist
			elseif not model.medications.valid_dose(medicine, dose) then
				create m.make_dose_outside_range
			else
				create m.make_ok
				model.add_medicine(id, medicine, dose)
			end
			model.default_update
			model.set_message(m)
			etf_cmd_container.on_change.notify ([Current])
		end

end
