note
	description: "Interactions between medications in EHEALTH system"
	author: "Siraj Rauff"
	date: "$Date$"
	revision: "$Revision$"

class
	INTERACTIONS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			interaction_id := 1
			create interaction_list.make (1)
			create ordered_interactions.make
		end

feature {NONE}
	interaction_list : HASH_TABLE[TUPLE[medicine1,medicine2: INTEGER], INTEGER]
	ordered_interactions : SORTED_TWO_WAY_LIST[INTEGER]
	interaction_id : INTEGER

feature
	access : EHEALTH_ACCESS

feature {EHEALTH}
	add_interaction(id1,id2: INTEGER)
		require
			ids_non_zero: id1 > 0 and id2 > 0
			ids_not_same: not (id1 = id2)
			medications_exist: access.m.medication_exists(id1) and access.m.medication_exists(id2)
			interaction_not_exists: not interaction_exists(id1,id2)
		do
			interaction_list.extend([id1, id2],interaction_id)
			ordered_interactions.extend (interaction_id)
			interaction_id := interaction_id + 1
		ensure
			id_increased: interaction_id = old interaction_id + 1
			interaction_exists: interaction_exists(id1,id2)
		end

feature -- public queries

	interaction_exists(id1,id2: INTEGER): BOOLEAN
		require
			not_negative: id1 > 0 and id2 > 0
			registered: access.m.medication_exists(id1) and access.m.medication_exists(id2)
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

	possible_dangerous_interactions(patient_id, medicine_id: INTEGER): BOOLEAN
		require
			not_negative: patient_id > 0 and medicine_id > 0
			reegistered: access.m.patient_exists(patient_id) and access.m.medication_exists(medicine_id)
		do
			Result := false
			across ordered_interactions as ordered_id loop
				if attached interaction_list.item (ordered_id.item) as interaction then
					if (interaction.medicine1 = medicine_id
							and access.m.patient_prescribed_medicine(patient_id, interaction.medicine2))
							or (interaction.medicine2 = medicine_id
							and access.m.patient_prescribed_medicine(patient_id, interaction.medicine1)) then
						Result := true
					end
				end
			end
		end

	patient_dangerous_interactions(patient_id: INTEGER): STRING
		require
			not_negative: patient_id > 0
			registered: access.m.patient_exists(patient_id)
		local
			exists : BOOLEAN
		do
			create Result.make_empty
			exists := false
			across ordered_interactions as ordered_interaction loop
				if attached interaction_list.item (ordered_interaction.item) as interaction then
					if access.m.patient_prescribed_medicine(patient_id, interaction.medicine1)
							and access.m.patient_prescribed_medicine(patient_id,  interaction.medicine2) then
						Result := Result + format_interactions(interaction.medicine1, interaction.medicine2) + ", "
						exists := true
					end
				end
			end
			if exists then
				Result.remove_tail(2)
			end
		end

	interactions_output: string
		do
			create Result.make_empty
			across ordered_interactions as ordered_id loop
				if attached interaction_list.item (ordered_id.item) as interaction then
					Result := Result + "%N    "
						+ format_interactions(interaction.medicine1,interaction.medicine2)
				end
			end
		end

	format_interactions(id1,id2: INTEGER): STRING
		require
			ids_positive: id1 > 0 and id2 > 0
			medications_exist:access.m.medication_exists(id1) and access.m.medication_exists(id2)
		local
			formatted1,formatted2 : STRING
		do
			create Result.make_empty
			formatted1 := access.m.format_medication(id1)
			formatted2 := access.m.format_medication(id2)
			if formatted1 < formatted2 then
				Result := Result + formatted1 + "->" + formatted2
			else
				Result := Result + formatted2 + "->" + formatted1
			end
		end

end
