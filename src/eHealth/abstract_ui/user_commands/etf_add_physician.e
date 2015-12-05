note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_ADD_PHYSICIAN
inherit
	ETF_ADD_PHYSICIAN_INTERFACE
		redefine add_physician end
create
	make
feature -- command
	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
		require else
			add_physician_precond(id, name, kind)
		local
			m : STATUS_MESSAGE
		do
			if id < 1 then
				create m.make_phys_id_pos
			elseif model.physicians.physician_exists (id) then
				create m.make_phys_id_in_use
			elseif not model.is_valid_string (name) then
				create m.make_name_start
			else
				create m.make_ok
				model.add_physician (id, name, kind)
			end
			model.default_update
			model.set_message(m)
			etf_cmd_container.on_change.notify ([Current])
		end

end
