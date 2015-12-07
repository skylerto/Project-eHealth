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
	ordered_physicians : SORTED_TWO_WAY_LIST[INTEGER]

feature
	access : EHEALTH_ACCESS

feature {EHEALTH} -- commands

	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
		require
			non_negative: id > 0
			valid_string: access.m.is_valid_string (name)
		do
			physician_list.extend ([name,kind], id)
			ordered_physicians.extend (id)
		ensure
			physician_added: physician_list.count = old physician_list.count + 1
			correct_physician_added: physician_exists(id)
		end

feature -- public queries

	physician_exists(physician_id: INTEGER): BOOLEAN
		require
			non_negative: physician_id > 0
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
					if (access.m.is_generalist(physician_tuple.kind)) then
						Result := Result + ",gn"
					elseif (access.m.is_specialist(physician_tuple.kind)) then
						Result := Result + ",sp"
					end
					Result := Result + "]"
				end
			end
		end

end
