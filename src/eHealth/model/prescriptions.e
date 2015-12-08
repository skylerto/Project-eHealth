note
	description: "Prescriptions for EHEALTH systems. Includes medications in prescriptions."
	author: "Siraj Rauff"
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
			registered: access.m.physician_exists (doctor) and access.m.patient_exists(patient)
			not_exists: not prescription_exists(doctor,patient)
		do
			prescription_list.extend ([doctor,patient, create {PRESCRIBED}.make],id)
			ordered_prescriptions.extend (id)
		ensure
			prescription_added: prescription_list.count = old prescription_list.count + 1
			correct_prescription: prescription_id_used(id) and prescription_exists(doctor,patient)
		end

	add_medicine(prescription_id: INTEGER ; medicine: INTEGER ; dose: VALUE)
		require
			not_negative: prescription_id > 0 and medicine > 0 and dose > 0.0
			registered: prescription_id_used(prescription_id) and access.m.medication_exists(medicine)
			not_prescribed: not medicine_prescribed(prescription_id, medicine)
			valid_dose: access.m.valid_dose(medicine, dose)
		do
			if attached prescription_list.item (prescription_id) as prescription_tuple then
				prescription_tuple.prescribed.add_medicine(medicine, dose)
			end
		ensure
			prescribed: medicine_prescribed(prescription_id, medicine)
		end

	remove_medicine(prescription_id: INTEGER ; medicine: INTEGER)
		require
			not_negative: prescription_id > 0 and medicine > 0
			registered: prescription_id_used (prescription_id) and access.m.medication_exists (medicine)
			prescribed: medicine_prescribed(prescription_id, medicine)
		do
			if attached prescription_list.item (prescription_id) as prescription_tuple then
				prescription_tuple.prescribed.remove_medicine(medicine)
			end
		ensure
			removed: not medicine_prescribed(prescription_id, medicine)
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
			registered: access.m.physician_exists (doctor) and access.m.patient_exists(patient)
		do
			across prescription_list as prescription loop
				if prescription.item.doctor = doctor and prescription.item.patient = patient then
					Result := true
				end
			end
		end

	medicine_prescribed(prescription_id, medicine_id : INTEGER): BOOLEAN
		require
			not_negative: prescription_id > 0 and medicine_id > 0
			exists: prescription_id_used(prescription_id)
		do
			Result := false
			if attached prescription_list.item (prescription_id) as prescription_tuple then
				Result := prescription_tuple.prescribed.medicine_prescribed(medicine_id)
			end
		end

	patient_prescribed_medicine(patient_id, medicine_id : INTEGER): BOOLEAN
		require
			not_negative: patient_id > 0 and medicine_id > 0
			registered: access.m.patient_exists(patient_id) and access.m.medication_exists(medicine_id)
		do
			Result := false
			across ordered_prescriptions as prescription loop
				if attached prescription_list.item (prescription.item) as prescription_tuple then
					if prescription_tuple.patient = patient_id and prescription_tuple.prescribed.medicine_prescribed(medicine_id) then
						Result := true
					end
				end
			end
		end

	prescribed_by_specialist(patient_id, medicine_id : INTEGER): BOOLEAN
		require
			not_negative: patient_id > 0 and medicine_id > 0
			registered: access.m.patient_exists(patient_id) and access.m.medication_exists(medicine_id)
		do
			Result := false
			across ordered_prescriptions as prescription loop
				if attached prescription_list.item (prescription.item) as prescription_tuple then
					if prescription_tuple.patient = patient_id
							and prescription_tuple.prescribed.medicine_prescribed(medicine_id)
							and access.m.physician_is_specialist(prescription_tuple.doctor) then
						Result := true
					end
				end
			end
		end

	dangerous_addition_allowed(prescription_id, medicine_id : INTEGER): BOOLEAN
		require
			not_negative: prescription_id > 0 and medicine_id > 0
			registered: prescription_id_used(prescription_id) and access.m.medication_exists(medicine_id)
		do
			Result := false
			if attached prescription_list.item (prescription_id) as prescription_tuple then
				if (access.m.physician_is_specialist(prescription_tuple.doctor)) or not (access.m.possible_dangerous_interactions(prescription_tuple.patient, medicine_id)) then
					Result := true
				end
			end
		end

	patient_dangerous_prescription(patient_id: INTEGER): BOOLEAN
		require
			not_negative: patient_id > 0
			registered: access.m.patient_exists(patient_id)
		do
			Result := false
			across ordered_prescriptions as prescription loop
				if attached prescription_list.item (prescription.item) as prescription_tuple then
				 	if prescription_tuple.patient = patient_id and prescription_tuple.prescribed.dangerous_interaction_exists then
						Result := true
					end
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
