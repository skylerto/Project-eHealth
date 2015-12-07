note
	description: "Summary description for {PATIENTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PATIENTS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			create patient_list.make (1)
			create ordered_patients.make
		end

feature {NONE}
	patient_list : HASH_TABLE[STRING, INTEGER]
	ordered_patients : SORTED_TWO_WAY_LIST[INTEGER]

feature
	access : EHEALTH_ACCESS

feature {EHEALTH} -- commands

	add_patient(id: INTEGER ; name: STRING)
		require
			non_negative: id > 0
			valid_string: access.m.is_valid_string (name)
			not_exists: not patient_exists(id)
		do
			patient_list.extend (name, id)
			ordered_patients.extend (id)
		ensure
			patient_added: patient_list.count = old patient_list.count + 1
			correct_patient_added: patient_exists(id)
		end

feature -- public queries

	patient_exists(patient_id: INTEGER): BOOLEAN
		require
			not_negative: patient_id > 0
		do
			Result := patient_list.has (patient_id)
		ensure
			actually_exits: patient_list.has (patient_id) = Result
		end

	patients_output: STRING
		do
			create Result.make_empty
			across ordered_patients as patient loop
				Result := Result + "%N    " + patient.item.out + "->"
				if attached patient_list.item (patient.item) as patientobject then
					Result := Result + patientobject
				end
			end
		end

end
