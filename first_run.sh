echo ""
echo "Provide name and full path of actys license file. e.g. $HOME/actys_licesne_xx"
read actys_license
echo "" 
echo ""
echo "--------------> Define ACTYS_HOME variable where Data folder is located e.g."
echo ""
echo "" 
echo "             export ACTYS_HOME=/home/${USER}/ACTYS"
echo ""
echo "=============> Enter the path for ACTYS_HOME variable"
read act_home
echo "export ACTYS_HOME=$act_home" >> ~/.bashrc	
echo "Check in the .bashrc file if ACTYS_HOME is defined"
tail ~/.bashrc
echo ""
echo "ACTYS_HOME is defined as $act_home" 
echo ""
cd ${act_home}/Data
echo""
echo "Copying license file to $act_home/Data"
cp $actys_license ${act_home}/Data/.
echo "Downloading EAF2010 libraries"
wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/EAF2010data.tar.bz2
echo "Doing untar of libraries"
tar --extract --file=EAF2010data.tar.bz2 $(tar -tf EAF2010data.tar.bz2 | grep fus)
mv EAF2010data EAF2010
find EAF2010 -type f -name '*fus*20100*' | while read f; do
    newname=$(echo "$f" | sed 's/20100/2010/g')
    mv "$f" "$newname"
done
echo "Downloading bin boundaries"
wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/ebins.tar.bz2
tar -xvjf ebins.tar.bz2
echo "Doing example run to test"
echo "Creating run directory if does not exits"
mkdir -p ${act_home}/run
cd ${act_home}/run
cp ${act_home}/examples_linux/CrW ${act_home}/run/.
cp ${act_home}/examples_linux/tripoli_flux ${act_home}/run/.
echo CrW | ../actyslinux
sleep 2
echo ""
echo ""
echo "Showing comparison of CrW.out from standard run with run on this system for user $USER"
echo ""
echo "!IMPORTANT "
echo " <<<< If there are significant difference in the output files. Please intimate to the actys@iterindia.in>>>"
sleep 3
echo "Press enter to show vimdiff comparison"
read *
vimdiff run/CrW.out examples_linux/CrW.out
echo ""
echo ""
echo "If there are significant difference in the output files. Please intimate to the actys@iterindia.in"
