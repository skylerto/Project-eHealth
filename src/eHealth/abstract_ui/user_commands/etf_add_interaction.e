note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_INTERACTION
inherit
	ETF_ADD_INTERACTION_INTERFACE
		redefine add_interaction end
create
	make
feature -- command
	add_interaction(id1: INTEGER ; id2: INTEGER)
		require else
			add_interaction_precond(id1, id2)
		local
			m : STATUS_MESSAGE
		do
			if id1 < 1 or id2 < 1 then
					create m.make_med_ids_pos
			elseif id1 = id2 then
				create m.make_med_ids_same
			elseif not (model.medication_exists(id1) and model.medication_exists(id2)) then
				create m.make_meds_not_reg
			elseif model.interaction_exists(id1,id2) then
				create m.make_interaction_exists
			elseif model.potential_interactions(id1,id2) then
				create m.make_conflicting_medicine
			else
				create m.make_ok
				model.add_interaction(id1,id2)
			end
			model.default_update
			model.set_message(m)
			etf_cmd_container.on_change.notify ([Current])
		end

end
