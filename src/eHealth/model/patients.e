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
			create ordered_patients_name.make
		end

feature {NONE}
	patient_list : HASH_TABLE[STRING, INTEGER]
	ordered_patients : SORTED_TWO_WAY_LIST[INTEGER]
	ordered_patients_name : SORTED_TWO_WAY_LIST[STRING]

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
			ordered_patients_name.extend (name)
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

	potential_interactions(medication_id1, medication_id2: INTEGER): BOOLEAN
		require
			not_negative: medication_id1 > 0 and medication_id2 > 0
			registered: access.m.medication_exists(medication_id1) and access.m.medication_exists(medication_id2)
		do
			Result := false
			across ordered_patients as patient loop
				if access.m.patient_prescribed_medicine(patient.item, medication_id1)
						and access.m.patient_prescribed_medicine(patient.item, medication_id2) then
					if not(access.m.prescribed_by_specialist(patient.item, medication_id1) or access.m.prescribed_by_specialist(patient.item, medication_id2)) then
						Result := true
					end
				end
			end
		end

	dangerous_prescriptions: STRING
		local
			prescriptions : STRING
			exists : BOOLEAN
			debug_string : STRING
		do
			create Result.make_empty
			create prescriptions.make_empty
			create debug_string.make_empty
			exists := false

			across ordered_patients_name as patient_name loop
				across ordered_patients as patient_id loop
					if attached patient_list.item (patient_id.item) as patient_object then
						if patient_object ~ patient_name.item and access.m.patient_dangerous_prescription(patient_id.item) then
							exists := true
							prescriptions := prescriptions + "%N    "
								+ format_patient(patient_id.item) + "->{ "
								+ access.m.patient_dangerous_interactions(patient_id.item) + " }"
						end
					end
				end
			end

			if exists then
				Result := "%N  There are dangerous prescriptions:" + prescriptions
			else
				Result := "%N  There are no dangerous prescriptions"
			end
		end

	patients_output: STRING
		do
			create Result.make_empty
			across ordered_patients as patient loop
				if attached patient_list.item (patient.item) as patient_object then
					Result := Result
						+ "%N    " + patient.item.out
						+ "->" + patient_object
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
