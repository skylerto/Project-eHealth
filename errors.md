
# eHealth System: Error Documentaion
**Team**: Siraj Rauff (212592192), Skyler Layne(212166906)  
**Date**: 23/11/2015  

\pagebreak

# List of Errors on User Operations

#### add_physician(id: ID_MD; name: NAME; kind: PHYSICIAN_TYPE)  
* Not enough arguments  
* *id* must be positive  
* *name* must be non-empty  
* Physician with *id* already exists  
* Physician with *name* already exists  
* *kind* must be generalist or specialist  

#### add_patient(id: ID_PT; name: NAME)  
* Not enough arguments  
* *id* must be positive  
* *name* must be non-empty  
* Patient with *id* already exists  
* Patient with *name* already exists  

#### add_medication(id: ID_MN; medicine: MEDICATION)  
* Not enough arguments  
* *id* must be positive  
* *name* must be non-empty  
* *kind* must be liquid or pill  
* *low dosage* must be positive  
* *high dosage* must be positive  
* *high dosage* must be greater than or equal to *low dosage*  
* Medication with *id* already exists  
* Medication with *name* already exists  

#### add_interaction(id1:ID_MN;id2:ID_MN)  
* Not enough arguments  
* *id1* must be positive  
* *id2* must be positive  
* No medication associated with *id1*  
* No medication associated with *id2*  
* Interaction already exists  

#### new_prescription(id: ID_RX; doctor: ID_MD; patient: ID_PT)  
* Not enough arguments  
* Medication *id* must be positive  
* Doctor *id* must be positive  
* Patient *id* must be positive  
* ID *ID_RX* already in use  
* No doctor associated with *ID_MD*  
* No patient associated with *ID_PT*  
* Prescription already exists  

#### add_medicine(id: ID_RX; medicine:ID_MN; dose: VALUE)  
* Not enough arguments  
* Prescription *id* must be positive  
* Medicine *id* must be positive  
* *dose* must be positive  
* No prescription associated with *ID_RX*  
* No medicine associated with *ID_MN*  
* *dose* must be higher than low dose of medicine  
* *dose* must be lower than high dose of medicine  
* Must be specialist to assign medicine with dangerous interaction  

#### remove_medicine(id: ID_RX; medicine:ID_MN)  
* Not enough arguments  
* Prescription *id* must be positive  
* Medicine *id* must be positive  
* No prescription associated with *ID_RX*  
* No medicine associated with *ID_MN*  
* Prescription *ID_RX* does not contain medicine *ID_MN*  

#### prescriptions_q(medication_id: ID_MN)  
* Not enough arguments  
* *id* must be positive  
* Medication *ID_MN* does not exist in any prescription  

#### dpr_q  
