#!/bin/bash

## Create dir
echo "Creating ehealth"
rm -rf ehealth/
mkdir ehealth


## Documents
echo "Copying TEX generated PDF to report location."
cp Latex/project-ehealth.pdf docs/ehealth.pdf
cp -r docs/ ehealth/docs


## PVS
echo "Copying PVS files to ehealth"
mkdir ehealth/pvs
cp pvs/ehealth.pvs ehealth/pvs/ehealth.pvs
cp pvs/ehealth.prf ehealth/pvs/ehealth.prf
cp pvs/Time.pvs ehealth/pvs/Time.pvs
cp pvs/Time.prf ehealth/pvs/Time.prf
cp pvs/top.pvs ehealth/pvs/top.pvs


## Source
echo "Copying source code to ehealth"
cp -r src/ ehealth/src

# local
# rm -rf ehealth/src/EIFGENs
# red
eclean ehealth/src


## Tests
echo "Copying tests to ehealth"
mkdir ehealth/tests
mkdir ehealth/tests/acceptance
mkdir ehealth/tests/acceptance/instructor
mkdir ehealth/tests/acceptance/student

cp tests/acceptance/instructor/at1.txt ehealth/tests/acceptance/instructor/at1.txt
cp tests/acceptance/student/at1.txt ehealth/tests/acceptance/student/at1.txt
cp tests/acceptance/student/at2.txt ehealth/tests/acceptance/student/at2.txt
cp tests/acceptance/student/at3.txt ehealth/tests/acceptance/student/at3.txt


## Build
echo "Building Project"
# local version
# ec -c_compile -finalize -project_path src/ -config ehealth/src/eHealth.ecf

# red
rm -rf /tmp/$USER
mkdir /tmp/$USER
ec15.08 -c_compile -finalize -project_path /tmp/$USER -config ehealth/src/eHealth.ecf


## Executable
echo "Moving executable"
mkdir ehealth/exe
# local
# cd ehealth/exe
# ln -s ../../src/EIFGENs/ehealth/F_code/eHealth ehealth.exe
# cd ../..
# red
mv /tmp/$USER/EIFGENs/ehealth/F_code/eHealth ehealth/exe/ehealth.exe


## Create expected outputs
echo "Creating .expected.txt files"
ehealth/exe/ehealth.exe -b ehealth/tests/acceptance/instructor/at1.txt > ehealth/tests/acceptance/instructor/at1.expected.txt
ehealth/exe/ehealth.exe -b ehealth/tests/acceptance/student/at1.txt > ehealth/tests/acceptance/student/at1.expected.txt
ehealth/exe/ehealth.exe -b ehealth/tests/acceptance/student/at2.txt > ehealth/tests/acceptance/student/at2.expected.txt
ehealth/exe/ehealth.exe -b ehealth/tests/acceptance/student/at3.txt > ehealth/tests/acceptance/student/at3.expected.txt


## Cleanup - FOR RED
echo "Cleaning up."
eclean /tmp/$USER
