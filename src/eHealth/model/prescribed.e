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
			medicine_order := 1
			create medicines_list.make (1)
			create ordered_medicines.make
		end

feature {NONE}
	medicines_list : HASH_TABLE[TUPLE[dose: VALUE ; id: INTEGER], INTEGER]
	ordered_medicines : SORTED_TWO_WAY_LIST[INTEGER]
	medicine_order: INTEGER

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
			medicines_list.extend ([dose, medicine_id], medicine_order)
			ordered_medicines.extend (medicine_order)
			medicine_order := medicine_order + 1
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
			across ordered_medicines as medicine loop
				if attached medicines_list.item (medicine.item) as medicine_tuple then
					if medicine_tuple.id = medicine_id then
						medicines_list.remove (medicine.item)
						ordered_medicines.prune_all (medicine.item)
					end
				end
			end
		ensure
			removed: not medicine_prescribed (medicine_id)
		end

feature -- public queries

	medicine_prescribed(medicine_id: INTEGER): BOOLEAN
		require
			not_negative: medicine_id > 0
		do
			Result := false
			across ordered_medicines as medicine loop
				if attached medicines_list.item (medicine.item) as medicine_tuple then
					if medicine_tuple.id = medicine_id then
						Result := true
					end
				end
			end
		end

	dangerous_interaction_exists: BOOLEAN
		do
			Result := false
			across ordered_medicines as orderedmedicine1 loop
				across ordered_medicines as orderedmedicine2 loop
					if not (orderedmedicine1.item = orderedmedicine2.item) and attached medicines_list.item (orderedmedicine1.item) as medicine1 and attached medicines_list.item (orderedmedicine2.item) as medicine2 then
						if access.m.interaction_exists(medicine1.id, medicine2.id) then
							Result := true
						end
					end
				end
			end
		end

	medicines_output: STRING
		do
			create Result.make_empty
			Result := Result + "("

			across ordered_medicines as medicine loop
				if attached medicines_list.item (medicine.item) as medicine_tuple then
					Result := Result + medicine_tuple.id.out + "->" + medicine_tuple.dose.out + ","
				end
			end

			if not (medicines_list.count = 0)then
				Result.remove_tail (1)
			end

			Result := Result + ")"
		end

end
