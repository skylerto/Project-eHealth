note
	description: "Summary description for {PHYSICIANS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PHYSICIANS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			create physician_list.make (1)
			create ordered_physicians.make
		end

feature {NONE}
	physician_list : HASH_TABLE[TUPLE[name: STRING; kind: INTEGER], INTEGER]
	ordered_physicians: LINKED_LIST[INTEGER]

feature {EHEALTH}-- commands

	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
		require
			non_negative: id > 0
			-- valid_string:
		do
			physician_list.extend ([name,kind], id)
			ordered_physicians.extend (id)
		ensure
			physician_added: physician_list.count = old physician_list.count + 1
			correct_physician_added: physician_exists(id)
		end

	remove_physician(physician_id: INTEGER)
		require
			positive: physician_id > 0
			exists: physician_exists (physician_id)
		do
			physician_list.remove (physician_id)
			ordered_physicians.prune_all (physician_id)
		ensure
			physician_removed: physician_list.count = old physician_list.count - 1
			correct_physician_removed: not physician_exists(physician_id)
		end

 feature  -- public queries

	physician_exists(physician_id: INTEGER): BOOLEAN
		require
			positive: physician_id > 0
		do
			Result := physician_list.has (physician_id)
		ensure
			actually_exits: physician_list.has (physician_id) = Result
		end

	physicians_output: STRING
		do
			create Result.make_empty
			across ordered_physicians as physician loop
				Result := Result + "%N    " + physician.item.out + "->"
				if attached physician_list.item (physician.item) as physician_tuple then
					Result := Result
						+ "[" + physician_tuple.name
						+ ","
					if (physician_tuple.kind = 0) then
						Result := Result + "gn"
					else
						Result := Result + "sp"
					end
					Result := Result + "]"
				end
			end
		end

end