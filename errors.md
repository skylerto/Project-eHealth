---

Date: 23/11/2015
Team: Siraj, Skyler
Doc: Error reports for eHealth system

---

# Errors in eHealth System
### Siraj Rauff
### Skyler Layne  



## List of Errors on User Operations

add_physician(id: ID_MD; name: NAME; kind: PHYSICIAN_TYPE)  
* Not enough arguments
* *id* must be positive
* *name* must be non-empty
* Physician with *id* already exists  
* Physician with *name* already exists
* *kind* must be generalist or specialist

add_patient(id: ID_PT; name: NAME)  
* Not enough arguments
* *id* must be positive
* *name* must be non-empty
* Patient with *id* already exists
* Patient with *name* already exists

add_medication(id: ID_MN; medicine: MEDICATION)  
* Not enough arguments
* *id* must be positive
* *name* must be non-empty
* *kind* must be liquid or pill
* *low dosage* must be positive
* *high dosage* must be positive
* *high dosage* must be greater than or equal to *low dosage*
* Medication with *id* already exists
* Medication with *name* already exists

add_interaction(id1:ID_MN;id2:ID_MN)  
* Not enough arguments
* *id1* must be positive
* *id2* must be positive
* No medication associated with *id1*
* No medication associated with *id2*
* Interaction already exists  

new_prescription(id: ID_RX; doctor: ID_MD; patient: ID_PT)
* Not enough arguments
* Medication *id* must be positive
* Doctor *id* must be positive
* Patient *id* must be positive
* ID *ID_RX* already in use
* Prescription already exists
* No doctor associated with *ID_MD*.
* No patient associated with *ID_PT*

add_medicine(id: ID_RX; medicine:ID_MN; dose: VALUE)  
* Not enough arguments
* Prescription *id* must be positive
* Medicine *id* must be positive
* *dose* must be positive
* No prescription associated with *ID_RX*
* No medicine associated with *ID_MN*
* *dose* must be higher than low dose of medicine
* *dose* must be lower than high dose of medicine
* Must be specialist to assign medicine with dangerous interaction

remove_medicine(id: ID_RX; medicine:ID_MN)  
* Not enough arguments
* Prescription *id* must be positive
* Medicine *id* must be positive
* No prescription associated with *ID_RX*
* No medicine associated with *ID_MN*
* Prescription *ID_RX* does not contain medicine *ID_MN*

prescriptions_q(medication_id: ID_MN)  
* Not enough arguments
* *id* must be positive
* Medication *ID_MN* does not exist in any prescription

  -- shows list of [patient,physician] with this medication  

dpr_q  
*  
    -- dangerous prescription report  
      -- PATIENT -> INTERACTION  

## Notes on Errors
### Derived from at1.expected.txt
Line 115 in at1.expected.txt: "->add_medication(5,["m4", liquid, 10, 25.5])" - Medication with this name already exists
Line 185 in at1.expected.txt: "->add_interaction(2,1)" - Interaction already exists
Line 166/204 in at1.expected.txt: "->add_interaction(1,2)" - Interaction already exists
