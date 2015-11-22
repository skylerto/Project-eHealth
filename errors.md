  


# Errors in eHealth System
### Siraj Rauff
### Skyler Layne  
      
        

## List of Errors on User Operations

add_physician(id: ID_MD; name: NAME; kind: PHYSICIAN_TYPE)  
* Physician with *id* already exists  
* Physician with *name* already exists  


add_patient(id: ID_PT; name: NAME)  
*  

add_medication(id: ID_MN; medicine: MEDICATION)  
*  

add_interaction(id1:ID_MN;id2:ID_MN)  
*  

new_prescription(id: ID_RX; doctor: ID_MD; patient: ID_PT)  
*  

add_medicine(id: ID_RX; medicine:ID_MN; dose: VALUE)  
*  

remove_medicine(id: ID_RX; medicine:ID_MN)  
*  


prescriptions_q(medication_id: ID_MN)  
*  
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
