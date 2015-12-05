note
	description: "Summary description for {MEDICATIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MEDICATIONS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			create medication_list.make (1)
			create ordered_medications.make
		end

feature {NONE}
	medication_list : HASH_TABLE[TUPLE[name: STRING; kind: INTEGER; low: VALUE; hi: VALUE],INTEGER]
	ordered_medications : SORTED_TWO_WAY_LIST[INTEGER]

feature {EHEALTH,ETF_ADD_MEDICATION}
	access : EHEALTH_ACCESS

feature {EHEALTH} -- commands
	add_medication(id: INTEGER ; medicine: TUPLE[name: STRING; kind: INTEGER; low: VALUE; hi: VALUE])
	require
		non_negative: id > 0
		valid_string: access.m.is_valid_string (medicine.name)
	do
		medication_list.extend (medicine, id)
		ordered_medications.extend (id)
	ensure
		medication_added : medication_list.count = old medication_list.count + 1
		correct_medication_added: medication_exists(id) and medication_name_used(medicine.name)
	end

feature {EHEALTH,ETF_ADD_MEDICATION} -- public queries

medication_exists(medication_id: INTEGER): BOOLEAN
	require
		positive: medication_id > 0
	do
		Result := medication_list.has (medication_id)
	ensure
		actually_exits: medication_list.has (medication_id) = Result
	end

medication_name_used(medication_name: STRING): BOOLEAN
	require
		valid_string: access.m.is_valid_string (medication_name)
	do
		across medication_list as medicine loop
			if medicine.item.name ~ medication_name then
				Result := true
			end
		end
	end

medications_output: STRING
	do
		create Result.make_empty
		across ordered_medications as medicine loop
			Result := Result + "%N    " + medicine.item.out + "->"
			if attached medication_list.item (medicine.item) as medicine_tuple then
				Result := Result	+ "[" + medicine_tuple.name

				if (access.m.is_pill(medicine_tuple.kind)) then
					Result := Result + ",pl"
				elseif (access.m.is_liquid(medicine_tuple.kind)) then
					Result := Result + ",lq"
				end

				Result := Result + ","
					+ medicine_tuple.low.out + ","
					+ medicine_tuple.hi.out + "]"
			end
		end
	end

end
