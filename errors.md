---

Date: 22/11/2015
Team: Siraj, Skyler
Doc: Error reports for eHealth system

---

# Errors in eHealth System
### Siraj Rauff
### Skyler Layne  
      
        

## List of Errors on User Operations

add_physician(id: ID_MD; name: NAME; kind: PHYSICIAN_TYPE)  
* Physician with *id* already exists  
* Physician with *name* already exists 
* *kind* must be generalist or specialist


add_patient(id: ID_PT; name: NAME)  
* Patient with *id* already exists
* Patient with *name* already exists 

add_medication(id: ID_MN; medicine: MEDICATION)  
* Medication with *id* already exists
* *medicine* already exists  
-- not to sure of this, need to review tests.  
--Some cases about what medicine is--  

add_interaction(id1:ID_MN;id2:ID_MN)  
* No medication with *id1*
* No medication with *id2*
* Interaction between these already exists  

new_prescription(id: ID_RX; doctor: ID_MD; patient: ID_PT)  
* Prescription with *id* already exists  
-- Patient already prescribed medication?  

add_medicine(id: ID_RX; medicine:ID_MN; dose: VALUE)  
*  Medicine with *id* already exists  

remove_medicine(id: ID_RX; medicine:ID_MN)  
*  Medicine with *id* does not exist
* *medicine* is not in the system  

prescriptions_q(medication_id: ID_MN)  
*  No medications with *id* exist  

  -- shows list of [patient,physician] with this medication  

dpr_q  
*  
    -- dangerous prescription report  
      -- PATIENT -> INTERACTION  

## Notes on Errors
### Derrived from at1.expected.txt
Line 115 in at1.expected.txt: "->add_medication(5,["m4", liquid, 10, 25.5])" - Medication with this name already exists
Line 185 in at1.expected.txt: "->add_interaction(2,1)" - Interaction already exists
Line 166/204 in at1.expected.txt: "->add_interaction(1,2)" - Interaction already exists
