note
	description: ""
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_DPR_Q
inherit
	ETF_DPR_Q_INTERFACE
		redefine dpr_q end
create
	make
feature -- command
	dpr_q
		do
			model.dpr_q
			model.default_update
			model.set_message(create {STATUS_MESSAGE}.make_ok)
			etf_cmd_container.on_change.notify ([Current])
		end

end
