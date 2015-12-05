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
			create message.make_ok
			create physicians.make
			create patients.make
			create medications.make
			create constraints
		end

feature -- model attributes
	i : INTEGER
	message : STATUS_MESSAGE
	physicians : PHYSICIANS
	patients : PATIENTS
	medications : MEDICATIONS
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
	do
	end

	add_medication(id: INTEGER ; medicine: TUPLE[name: STRING; kind: INTEGER; low: VALUE; hi: VALUE])
	require
		non_negative: id > 0
		valid_string: is_valid_string (medicine.name)
		-- name_unused: not medications.medication_name_used(medicine.name)
	do
		medications.add_medication(id, medicine)
	ensure
		medication_added: medications.medication_exists(id) and
			medications.medication_name_used(medicine.name)
	end

	add_medicine(id: INTEGER ; medicine: INTEGER ; dose: VALUE)
	do
	end

	add_patient(id: INTEGER ; name: STRING)
	require
		valid_name: is_valid_string (name)
		not_exists: not patients.patient_exists (id)
	do
		patients.add_patient (id, name)
	ensure
		patient_added: patients.patient_exists(id)
	end

	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
	require
		valid_name: is_valid_string (name)
		not_exists: not physicians.physician_exists (id)
	do
		physicians.add_physician (id, name, kind)
	ensure
		physician_added: physicians.physician_exists(id)
	end

	new_prescription(id: INTEGER ; doctor: INTEGER ; patient: INTEGER)
	do
	end

	remove_medicine(id: INTEGER ; medicine: INTEGER)
	do
	end

feature -- queries
	dpr_q
	do
	end

	prescriptions_q(medication_id: INTEGER)
	do
	end

	out : STRING
		do
			Result :=
				"  " + i.out + ": " + message.out +
				"%N  Physicians:" + physicians.physicians_output +
				"%N  Patients:" + patients.patients_output +
				"%N  Medications:" + medications.medications_output +
				"%N  Interactions:" +
				"%N  Prescriptions:"
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
