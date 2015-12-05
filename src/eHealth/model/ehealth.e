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
			create s.make_empty
			i := 0
			create message.make_ok
		end

feature -- model attributes
	s : STRING
	i : INTEGER
	message : STATUS_MESSAGE

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
    do
    end

  add_medicine(id: INTEGER ; medicine: INTEGER ; dose: VALUE)
    do
    end

 	add_patient(id: INTEGER ; name: STRING)
	   do
    end

 	add_physician(id: INTEGER ; name: STRING ; kind: INTEGER)
	   do
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
			create Result.make_from_string ("  System State: default model state (" + i.out + ")")
		end

end
