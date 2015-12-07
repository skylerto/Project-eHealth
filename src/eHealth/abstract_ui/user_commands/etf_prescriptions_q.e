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
		local
			m : STATUS_MESSAGE
		do
			if medication_id < 1 then
				create m.make_med_id_pos
			elseif not model.medications.medication_exists(medication_id) then
				create m.make_med_not_reg
			else
				create m.make_ok
				model.prescriptions_q(medication_id)
			end
			model.set_message(m)
			model.default_update
			etf_cmd_container.on_change.notify ([Current])
		end

end
