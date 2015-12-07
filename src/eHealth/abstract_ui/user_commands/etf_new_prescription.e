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
		local
			m : STATUS_MESSAGE
  	do
			if id < 1 then
				create m.make_presc_id_pos
			elseif model.prescriptions.prescription_id_used(id) then
				create m.make_presc_id_in_use
			elseif doctor < 1 then
				create m.make_phys_id_pos
			elseif not model.physicians.physician_exists(doctor) then
				create m.make_phys_not_reg
			elseif patient < 1 then
				create m.make_patient_id_pos
			elseif not model.patients.patient_exists(patient) then
				create m.make_patient_not_reg
			elseif model.prescriptions.prescription_exists(doctor,patient) then
				create m.make_presc_exists
			else
				create m.make_ok
				model.new_prescription(id, doctor, patient)
			end
			model.default_update
			model.set_message(m)
			etf_cmd_container.on_change.notify ([Current])
  	end

end
