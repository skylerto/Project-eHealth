note
	description: "A default business model."
	author: "Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	EHEALTH

inherit
	ANY
		redefine
			out
		end

create {EHEALTH_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			i := 0
			state := [0,0,0]
			create message.make_ok
			create physicians.make
			create patients.make
			create medications.make
			create interactions.make
			create prescriptions.make
			create constraints
		end

feature -- model attributes
	i : INTEGER
	state : TUPLE[command : INTEGER ; report_type : INTEGER ; medication : INTEGER]
	message : STATUS_MESSAGE
	physicians : PHYSICIANS
	patients : PATIENTS
	medications : MEDICATIONS
	interactions : INTERACTIONS
	prescriptions : PRESCRIPTIONS
	constraints : ETF_TYPE_CONSTRAINTS

feature -- model operations

	set_message(m: STATUS_MESSAGE)
		do
			message := m
		end

	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

feature -- commands
	add_interaction(id1: INTEGER; id2: INTEGER)
	require
		not_negative: id1 > 0 and id2 > 0
		ids_not_same: not (id1 = id2)
		medications_exist: medications.medication_exists(id1) and medications.medication_exists(id2)
		interaction_not_exists: not interactions.interaction_exists(id1,id2)
		-- First remove conflicint medicine prescribed by generalist
	do
		interactions.add_interaction(id1,id2)
	ensure
		interaction_added: interactions.interaction_exists(id1,id2)
	end

	add_medication(id: INTEGER ; medicine: TUPLE[name: STRING; kind: INTEGER; low: VALUE; hi: VALUE])
	require
		not_negative: id > 0
		not_already_exists: not medications.medication_exists(id)
		valid_string: is_valid_string (medicine.name)
		name_not_used: not medications.medication_name_used(medicine.name)
		valid_range: 0.0 < medicine.low and medicine.low <= medicine.hi
	do
		medications.add_medication(id, medicine)
	ensure
		medication_added: medications.medication_exists(id) and
			medications.medication_name_used(medicine.name)
	end

	add_medicine(id: INTEGER ; medicine: INTEGER ; dose: VALUE)
	require
		not_negative: id > 0 and medicine > 0 and dose > 0.0
		registered: prescriptions.prescription_id_used(id) and medications.medication_exists(medicine)
		not_prescribed: not prescriptions.medicine_prescribed(id, medicine)
		valid_dose: medications.valid_dose(medicine, dose)
	do
		prescriptions.add_medicine(id, medicine, dose)
	ensure
		prescribed: prescriptions.medicine_prescribed(id, medicine)
	end

	add_patient(id: INTEGER ; name: STRING)
	require
		not_negative: id > 0
		valid_name: is_valid_string (name)
		not_exists: not patients.patient_exists (id)
	do
		patients.add_patient (id, name)
	ensure
		patient_added: patients.patient_exists(id)
	end

	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
	require
		not_negative: id > 0
		valid_name: is_valid_string (name)
		not_exists: not physicians.physician_exists (id)
	do
		physicians.add_physician (id, name, kind)
	ensure
		physician_added: physicians.physician_exists(id)
	end

	new_prescription(id: INTEGER ; doctor: INTEGER ; patient: INTEGER)
	require
		not_negative: id > 0 and doctor > 0 and patient > 0
		id_not_used: not prescriptions.prescription_id_used (id)
		registered: physicians.physician_exists (doctor) and patients.patient_exists (patient)
		not_exists: not prescriptions.prescription_exists (doctor,patient)
	do
		prescriptions.new_prescription(id, doctor, patient)
	ensure
		added: prescriptions.prescription_id_used(id) and prescriptions.prescription_exists(doctor, patient)
	end

	remove_medicine(id: INTEGER ; medicine: INTEGER)
	require
		not_negative: id > 0 and medicine > 0
		registered: prescriptions.prescription_id_used (id) and medications.medication_exists (medicine)
		prescribed: prescriptions.medicine_prescribed(id, medicine)
	do
		prescriptions.remove_medicine(id, medicine)
	ensure
		removed: not prescriptions.medicine_prescribed(id, medicine)
	end

feature -- queries
	dpr_q
	do
		state.command := 1
		state.report_type := 1
	end

	prescriptions_q(medication_id: INTEGER)
	do
		state.command := 1
		state.report_type := 2
		state.medication := medication_id
	end

feature -- queries

	out : STRING
		do
			create Result.make_empty
			if state.command = 0 then
				Result := "  " + i.out + ": " + message.out
					+ "%N  Physicians:" + physicians.physicians_output
					+ "%N  Patients: " + patients.patients_output
					+ "%N  Medications: " + medications.medications_output
					+ "%N  Interactions: " + interactions.interactions_output
					+ "%N  Prescriptions:" + prescriptions.prescriptions_output

			elseif state.command = 1 then
				if state.report_type = 1 then
					Result := "  " + i.out + ": " + message.out
						+ prescriptions.dangerous_prescriptions

				elseif state.report_type = 2 then
					Result := "  " + i.out + ": " + message.out
						+ "%N  Output: medication is "
						+ medications.medication_info(state.medication)
						+ patients.patients_prescribed_medicine(state.medication)
				end
			end
			state := [0,0,0]
		end

	is_pill(kind: INTEGER) : BOOLEAN
		require
			constraints.is_kind (kind)
		do
			Result := "pill" ~ constraints.enum_items_inverse.at (kind)
		end

	is_liquid(kind: INTEGER) : BOOLEAN
		require
			constraints.is_kind (kind)
		do
			Result := "liquid" ~ constraints.enum_items_inverse.at (kind)
		end

	is_generalist(kind: INTEGER) : BOOLEAN
		require
			constraints.is_physician_type (kind)
		do
			Result := "generalist" ~ constraints.enum_items_inverse.at (kind)
		end

	is_specialist(kind: INTEGER) : BOOLEAN
		require
			constraints.is_physician_type (kind)
		do
			Result := "specialist" ~ constraints.enum_items_inverse.at (kind)
		end

feature {ANY}-- valid names

	is_valid_string(a_name:STRING): BOOLEAN
		do
			Result := a_name.count >= 1
			Result := Result
				and then is_ascii_character(a_name[1])
	ensure
			Result implies a_name.count >= 1
			Result implies is_ascii_character(a_name[1])
		end

	is_ascii_character(c: CHARACTER): BOOLEAN
		do
			Result := (65 <= c.code and c.code <= 90)
				or (97 <= c.code and c.code <= 172)
		ensure
			Result = (65 <= c.code and c.code <= 90)
				or (97 <= c.code and c.code <= 172)
		end

end
