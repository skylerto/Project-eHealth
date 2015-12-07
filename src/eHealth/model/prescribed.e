note
	description: "Medicines in a particular prescription in the EHEALTH system"
	author: "Siraj Rauff"
	date: "$Date$"
	revision: "$Revision$"

class
	PRESCRIBED
create {PRESCRIPTIONS}
	make
feature {NONE}
	make
		do
			create medicines_list.make (1)
			create ordered_medicines.make
		end

feature {NONE}
	medicines_list : HASH_TABLE[VALUE, INTEGER]
	ordered_medicines : SORTED_TWO_WAY_LIST[INTEGER]

feature
	access : EHEALTH_ACCESS

feature {PRESCRIPTIONS} -- commands

	add_medicine (medicine_id: INTEGER ; dose: VALUE)
		require
			not_negative: medicine_id > 0 and dose > 0.0
			medication_registered: access.m.medication_exists(medicine_id)
			not_exists: not medicine_prescribed(medicine_id)
			dose_in_range: access.m.valid_dose(medicine_id, dose)
		do
			medicines_list.extend (dose, medicine_id)
			ordered_medicines.extend (medicine_id)
		ensure
			medicine_added: medicines_list.count = old medicines_list.count + 1
			correct_medicine: medicine_prescribed(medicine_id)
		end

	remove_medicine (medicine_id: INTEGER)
		require
			not_negative: medicine_id > 0
			registered: access.m.medication_exists (medicine_id)
			prescribed: medicine_prescribed (medicine_id)
		do
			medicines_list.remove (medicine_id)
			ordered_medicines.prune_all (medicine_id)
		ensure
			removed: not medicine_prescribed (medicine_id)
		end

feature -- public queries

	medicine_prescribed(medicine_id: INTEGER): BOOLEAN
		require
			not_negative: medicine_id > 0
		do
			Result := medicines_list.has (medicine_id)
		ensure
			actually_exists: medicines_list.has (medicine_id) = Result
		end

	dangerous_interaction_exists: BOOLEAN
		do
			Result := false
			across ordered_medicines as medicine1 loop
				across ordered_medicines as medicine2 loop
					if access.m.interaction_exists(medicine1.item, medicine2.item) then
						Result := true
					end
				end
			end
		end

	medicines_output: STRING
		do
			create Result.make_empty
			Result := Result + "("
			across ordered_medicines as medicine loop
				if attached medicines_list.item (medicine.item) as dose then
					Result := Result + medicine.item.out + "->" + dose.out + ","
				end
			end
			if not (medicines_list.count = 0)then
				Result.remove_tail (1)
			end
			Result := Result + ")"
		end

end
