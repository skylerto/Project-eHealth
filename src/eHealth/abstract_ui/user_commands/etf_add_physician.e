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
    	do
     		if id < 0 then
        		-- ERROR: physician id must be a positive integer
      		elseif false then
        		-- ERROR: physician id already in use
      		elseif false then
        		-- ERROR: name must start with a letter
      		else
  				model.default_update
  				etf_cmd_container.on_change.notify ([Current])
      		end
    	end

end
