note
	description: "Summary description for {MY_BAG_ITERATION_CURSOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MY_BAG_ITERATION_CURSOR [G -> {HASHABLE, COMPARABLE}]
inherit
	ITERATION_CURSOR [G]
create
	make

feature -- creation
	make(iteration_bag: HASH_TABLE[INTEGER, G])
		require
			iteration_bag_attached: iteration_bag /= Void
		do
			cursor := iteration_bag.new_cursor
			iteration_bag.start
		end

feature -- attributes
	cursor: HASH_TABLE_ITERATION_CURSOR [INTEGER, G]

feature -- queries
	item: G
		do
			Result := cursor.key
		end

	after: BOOLEAN
		do
			Result := cursor.after
		end

feature -- commands
	forth
		do
			cursor.forth
		end
end
