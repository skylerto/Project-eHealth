note
	description: "Patients in the EHEALTH system."
	author: "Siraj Rauff"
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

	patients_prescribed_medicine(medication_id: INTEGER): STRING
		require
			not_negative: medication_id > 0
			registered: access.m.medication_exists(medication_id)
		do
			create Result.make_empty
			across ordered_patients as patient loop
				if attached patient_list.item (patient.item) as patientobject then
					if access.m.patient_prescribed_medicine(patient.item, medication_id) then
						Result := Result
							+ "%N    " + patient.item.out
							+ "->" + patientobject
					end
				end
			end
		end

	patients_output: STRING
		do
			create Result.make_empty
			across ordered_patients as patient loop
				if attached patient_list.item (patient.item) as patientobject then
					Result := Result
						+ "%N    " + patient.item.out
						+ "->" + patientobject
				end
			end
		end

	format_patient(patient_id: INTEGER):STRING
		require
			not_negative: patient_id > 0
			registered: patient_exists(patient_id)
		do
			create Result.make_empty
			if attached patient_list.item (patient_id) as patient then
				Result := "(" + patient + "," + patient_id.out + ")"
			end
		end

end
