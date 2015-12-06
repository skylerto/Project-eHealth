note
	description: "Summary description for {INTERACTIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INTERACTIONS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			create interaction_list.make (1)
			interaction_id := 0
			create ordered_interactions.make
		end

feature {NONE}
	interaction_list : HASH_TABLE[TUPLE[medicine1,medicine2:INTEGER],INTEGER]
	ordered_interactions : SORTED_TWO_WAY_LIST[INTEGER]
	interaction_id : INTEGER

feature
	access : EHEALTH_ACCESS

feature {EHEALTH}
	add_interaction(id1,id2: INTEGER)
	require
		ids_non_zero: id1 > 0 and id2 > 0
		ids_not_same: not (id1 = id2)
		medications_exist: access.m.medications.medication_exists(id1) and access.m.medications.medication_exists(id2)
		interaction_not_exists: not interaction_exists(id1,id2)
	do
		interaction_list.extend([id1, id2],interaction_id)
		ordered_interactions.extend (interaction_id)
		interaction_id := interaction_id + 1
	end

feature -- public queries

	interaction_exists(id1,id2: INTEGER): BOOLEAN
	do
		Result := false
		across ordered_interactions as ordered_id loop
			if attached interaction_list.item (ordered_id.item) as interaction then
				if interaction.medicine1 = id1 and interaction.medicine2 = id2 or interaction.medicine1 = id2 and interaction.medicine2 = id1 then
					Result := true
				end
			end
		end
	end

	interactions_output: string
		do
			create Result.make_empty
			across ordered_interactions as ordered_id loop
				if attached interaction_list.item (ordered_id.item) as interaction then
					Result := Result + format_interactions(interaction.medicine1,interaction.medicine2)
				end
			end
		end

	format_interactions(id1,id2: INTEGER): STRING
		require
			ids_positive: id1 > 0 and id2 > 0
			medications_exist:access.m.medications.medication_exists(id1) and access.m.medications.medication_exists(id2)
		local
			formatted1,formatted2 : STRING
		do
			create Result.make_empty
			formatted1 := access.m.medications.format_medication(id1)
			formatted2 := access.m.medications.format_medication(id2)
			Result := Result + "%N    "
			if formatted1 < formatted2 then
				Result := Result + formatted1 + "->" + formatted2
			else
				Result := Result + formatted2 + "->" + formatted1
			end
		end

end
