note
	description: "Summary description for {PRESCRIPTIONS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PRESCRIPTIONS
create {EHEALTH}
	make
feature {NONE}
	make
		do
			create prescription_list.make (1)
			create ordered_prescriptions.make
		end

feature
	access : EHEALTH_ACCESS

feature {NONE}
	prescription_list : HASH_TABLE[TUPLE[doctor, patient: INTEGER; prescribed : PRESCRIBED], INTEGER]
	ordered_prescriptions : SORTED_TWO_WAY_LIST[INTEGER]

feature {EHEALTH}

	new_prescription(id: INTEGER ; doctor: INTEGER ; patient: INTEGER)
	require
		non_negative: id > 0 and doctor > 0 and patient > 0
		id_not_used: not prescription_id_used(id)
		registered: access.m.physicians.physician_exists (doctor) and access.m.patients.patient_exists(patient)
		not_exists: not prescription_exists(doctor,patient)
	do
		prescription_list.extend ([doctor,patient, create {PRESCRIBED}.make],id)
		ordered_prescriptions.extend (id)
	ensure
		prescription_added: prescription_list.count = old prescription_list.count + 1
		correct_prescription: prescription_id_used(id) and prescription_exists(doctor,patient)
	end

feature -- public queries
	prescription_id_used(prescription_id: INTEGER): BOOLEAN
		require
			non_negative: prescription_id > 0
		do
			Result := prescription_list.has (prescription_id)
		ensure
			actually_exists: prescription_list.has (prescription_id) = Result
		end

	prescription_exists(doctor, patient: INTEGER): BOOLEAN
		require
			non_negative: doctor > 0 and patient > 0
			registered: access.m.physicians.physician_exists (doctor) and access.m.patients.patient_exists(patient)
		do
			across prescription_list as prescription loop
				if prescription.item.doctor = doctor and prescription.item.patient = patient then
					Result := true
				end
			end
		end

	prescriptions_output: STRING
		do
			create Result.make_empty
			across ordered_prescriptions as prescription loop
				Result := Result + "%N    " + prescription.item.out + "->"
				if attached prescription_list.item (prescription.item) as prescription_tuple then
					Result := Result	+ "["
						+ prescription.item.out + ","
						+ prescription_tuple.doctor.out + ","
						+ prescription_tuple.patient.out + ","
						+ prescription_tuple.prescribed.medicines_output + "]"
				end
			end

		end
end
