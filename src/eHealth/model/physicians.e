note
	description: "Summary description for {PHYSICIANS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHYSICIANS
create
	make
feature {NONE}
	make
		do
			create physician_list.make (1)
			create ordered_physicians.make
		end

feature {NONE}
	physician_list : HASH_TABLE[MY_BAG[STRING], INTEGER]
	ordered_physicians: LINKED_LIST[INTEGER]

-- feature -- commands

--	add_physician(a_physician: TUPLE[: STRING; no: INTEGER])
--		require
--			non_negative: a_physician[1] > 0
--		do
--			current_physician := next_physician_id
--			physician_list.extend (a_physician, current_physician)
--			ordered_ids.extend (current_physician)
--		ensure
--			physician_added: physician_list.count = old physician_list.count + 1
--			correct_physician_added: physician_exists(current_physician)
--		end
--
--	remove_physician(physician_id: INTEGER)
--		require
--			positive: physician_id > 0
--			exists: physician_exists (physician_id)
--		do
--			physician_list.remove (physician_id)
--			ordered_ids.prune_all (physician_id)
--		ensure
--			physician_removed: physician_list.count = old physician_list.count - 1
--			correct_physician_removed: not physician_e`xists(physician_id)
--		end

-- feature -- public queries

--	duplicates_in_array(a_array: ARRAY[TUPLE[pid: STRING; no: INTEGER]]): BOOLEAN
--		local
--			test_table: HASH_TABLE[INTEGER, STRING]
--		do
--			Result := false
--			if not a_array.is_empty then
--				create test_table.make (0)
--				across a_array as product loop
--					if test_table.has(product.item.pid) then
--						Result := true
--					else
--						test_table.extend(0, product.item.pid)
--					end
--				end
--			end
--		end

--	physician_exists(physician_id: INTEGER): BOOLEAN
--		require
--			positive: physician_id > 0
--		do
--			Result := physician_list.has (physician_id)
--		end

--	physicians_output: STRING
--		do
--			create Result.make_empty
--			across ordered_ids as order loop
--				Result := Result + order.item.out + ": "
--				if attached physician_list.item (order.item) as current_physician_bag then
--					if attached current_physician_bag.domain as products then
--						across products as product loop
--							Result := Result + product.item.out + "->" + current_physician_bag.occurrences (product.item).out + ","
--						end
--					end
--				end
--				Result.remove_tail (1)
--				Result := Result + "%N               "
--			end
--			Result.remove_tail (16)
--			Result := Result + "%N"
--		end

end
