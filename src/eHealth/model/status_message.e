note
	description: "Summary description for {STATUS_MESSAGE}."
	author: "created by JSO, modified by Siraj Rauff for EHEALTH"
	date: "$Date$"
	revision: "$Revision$"

class
	STATUS_MESSAGE

	inherit
		ANY
			redefine out end

		create
			make_ok,
			make_phys_id_pos,
			make_phys_id_in_use,
			make_name_start,
			make_patient_id_pos,
			make_patient_id_in_use,
			make_med_id_pos,
			make_med_id_in_use,
			make_med_name_start,
			make_med_name_in_use,
			make_valid_range,
			make_med_ids_pos,
			make_med_ids_same,
			make_meds_not_reg,
			make_interaction_exists,
			make_conflicting_medicine,
			make_presc_id_pos,
			make_presc_id_in_use,
			make_phys_not_reg,
			make_patient_not_reg,
			make_presc_exists,
			make_presc_not_exists,
			make_med_not_reg,
			make_med_is_presc,
			make_not_specialist,
			make_dose_outside_range,
			make_med_not_in_presc

		feature {NONE} -- Initialization

		  make_ok
				do
					err_code := err_ok
				end
		  make_phys_id_pos
				do
					err_code := err_phys_id_pos
				end
		  make_phys_id_in_use
				do
					err_code := err_phys_id_in_use
				end
		  make_name_start
				do
					err_code := err_name_start
				end
		  make_patient_id_pos
				do
					err_code := err_patient_id_pos
				end
		  make_patient_id_in_use
				do
					err_code := err_patient_id_in_use
				end
		  make_med_id_pos
				do
					err_code := err_med_id_pos
				end
		  make_med_id_in_use
				do
					err_code := err_med_id_in_use
				end
		  make_med_name_start
				do
					err_code := err_med_name_start
				end
		  make_med_name_in_use
				do
					err_code := err_med_name_in_use
				end
		  make_valid_range
				do
					err_code := err_valid_range
				end
		  make_med_ids_pos
				do
					err_code := err_med_ids_pos
				end
		  make_med_ids_same
				do
					err_code := err_med_ids_same
				end
		  make_meds_not_reg
				do
					err_code := err_meds_not_reg
				end
		  make_interaction_exists
				do
					err_code := err_interaction_exists
				end
		  make_conflicting_medicine
				do
					err_code := err_conflicting_medicine
				end
		  make_presc_id_pos
				do
					err_code := err_presc_id_pos
				end
		  make_presc_id_in_use
				do
					err_code := err_presc_id_in_use
				end
		  make_phys_not_reg
				do
					err_code := err_phys_not_reg
				end
		  make_patient_not_reg
				do
					err_code := err_patient_not_reg
				end
		  make_presc_exists
				do
					err_code := err_presc_exists
				end
		  make_presc_not_exists
				do
					err_code := err_presc_not_exists
				end
		  make_med_not_reg
				do
					err_code := err_med_not_reg
				end
		  make_med_is_presc
				do
					err_code := err_med_is_presc
				end
		  make_not_specialist
				do
					err_code := err_not_specialist
				end
		  make_dose_outside_range
				do
					err_code := err_dose_outside_range
				end
		  make_med_not_in_presc
				do
					err_code := err_med_not_in_presc
				end

		feature -- Output

			out: STRING
					-- string representation of current status message
				do
					Result := err_message [err_code]
				end

		feature {NONE} -- Implementation

			err_code: INTEGER

			err_message: ARRAY[STRING]
				once
					create Result.make_filled ("", 1, 27)
					Result.put ("ok",1)
					Result.put ("physician id must be a positive integer",2)
					Result.put ("physician id already in use",3)
					Result.put ("name must start with a letter", 4)
					Result.put ("patient id must be a positive integer", 5)
					Result.put ("patient id already in use", 6)
					Result.put ("medication id must be a positive integer", 7)
					Result.put ("medication id already in use", 8)
					Result.put ("medication name must start with a letter", 9)
					Result.put ("medication name already in use", 10)
					Result.put ("require 0 < low-dose <= hi-dose", 11)
					Result.put ("medication ids must be positive integers", 12)
					Result.put ("medication ids must be different", 13)
					Result.put ("medications with these ids must be registered", 14)
					Result.put ("interaction already exists", 15)
					Result.put ("first remove conflicting medicine prescribed by generalist", 16)
					Result.put ("prescription id must be a positive integer", 17)
					Result.put ("prescription id already in use", 18)
					Result.put ("physician with this id not registered", 19)
					Result.put ("patient with this id not registered", 20)
					Result.put ("prescription already exists for this physician and patient", 21)
					Result.put ("prescription with this id does not exist", 22)
					Result.put ("medication id must be registered", 23)
					Result.put ("medication is already prescribed", 24)
					Result.put ("specialist is required to add a dangerous interaction", 25)
					Result.put ("dose is outside allowed range", 26)
					Result.put ("medication is not in the prescription", 27)
				end

		  err_ok: INTEGER = 1
		  err_phys_id_pos : INTEGER = 2
		  err_phys_id_in_use: INTEGER = 3
		  err_name_start: INTEGER = 4
		  err_patient_id_pos: INTEGER = 5
		  err_patient_id_in_use: INTEGER = 6
		  err_med_id_pos: INTEGER = 7
		  err_med_id_in_use: INTEGER = 8
		  err_med_name_start: INTEGER = 9
		  err_med_name_in_use: INTEGER = 10
		  err_valid_range: INTEGER = 11
		  err_med_ids_pos: INTEGER = 12
		  err_med_ids_same: INTEGER = 13
		  err_meds_not_reg: INTEGER = 14
		  err_interaction_exists: INTEGER = 15
		  err_conflicting_medicine: INTEGER = 16
		  err_presc_id_pos: INTEGER = 17
		  err_presc_id_in_use: INTEGER = 18
		  err_phys_not_reg: INTEGER = 19
		  err_patient_not_reg: INTEGER = 20
		  err_presc_exists: INTEGER = 21
		  err_presc_not_exists: INTEGER = 22
		  err_med_not_reg: INTEGER = 23
		  err_med_is_presc: INTEGER = 24
		  err_not_specialist: INTEGER = 25
		  err_dose_outside_range: INTEGER = 26
		  err_med_not_in_presc: INTEGER = 27

			valid_message(a_message_no:INTEGER): BOOLEAN
				do
					Result := err_message.lower <= a_message_no
						and a_message_no <= err_message.upper
				ensure
					Result =( err_message.lower <= a_message_no
						and a_message_no <= err_message.upper)
				end

end
