#!/bin/bash

# Create dir
echo "Creating ehealth"
rm -rf ehealth/
mkdir ehealth

# Documents
echo "Copying TEX generated PDF to report location."
cp Latex/project-ehealth.pdf docs/ehealth.pdf
cp -r docs/ ehealth/docs

# PVS
echo "Copying PVS files to ehealth"
mkdir ehealth/pvs
cp PVS/ehealth.pvs ehealth/pvs/ehealth.pvs
cp PVS/ehealth.prf ehealth/pvs/ehealth.prf
cp PVS/Time.pvs ehealth/pvs/Time.pvs
cp PVS/Time.prf ehealth/pvs/Time.prf
cp PVS/top.pvs ehealth/pvs/top.pvs

# Source
echo "Copying source code to ehealth"
cp -r src/ ehealth/src

# local
# rm -rf ehealth/src/EIFGENs
# red
eclean ehealth/src

# Tests
echo "Copying tests to ehealth"
cp -r tests/ ehealth/tests
rm -f ehealth/tests/acceptance/instructor/*actual*
rm -f ehealth/tests/acceptance/student/*actual*

## Build
echo "Building Project"
# local version
# ec -c_compile -finalize -project_path src/ -config ehealth/src/eHealth.ecf

# red
rm -rf /tmp/$USER
mkdir /tmp/$USER
ec15.08 -c_compile -finalize -project_path /tmp/$USER -config ehealth/src/eHealth.ecf

# Executable
echo "Moving executable"
mkdir ehealth/exe
# local
# cd ehealth/exe
# ln -s ../../src/EIFGENs/ehealth/F_code/eHealth ehealth.exe
# cd ../..
# red
mv /tmp/$USER/EIFGENs/ehealth/F_code/eHealth ehealth/exe/ehealth.exe

# Cleanup - FOR RED
echo "Cleaning up."
eclean /tmp/$USER
