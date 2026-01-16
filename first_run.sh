echo "--------------> Define ACTYS_HOME variable where Data folder is located e.g."
echo ""

echo "             export ACTYS_HOME=/home/${USER}/ACTYS"
echo "" 
echo ""
echo "=============> Enter the path for ACTYS_HOME variable"
read act_home
echo "export ACTYS_HOME=$act_home" >> ~/.bashrc	
tail ~/.bashrc
echo ""
echo "ACTYS_HOME is defined as $act_home" 
cd ${act_home}/Data
echo "Downloading EAF2010 libraries"
#wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/EAF2010data.tar.bz2
echo "Doing untar of libraries"
tar --extract --file=EAF2010data.tar.bz2 $(tar -tf EAF2010data.tar.bz2 | grep fus)
mv EAF2010data EAF2010
find EAF2010 -type f -name '*fus*20100*' | while read f; do
    newname=$(echo "$f" | sed 's/20100/2010/g')
    mv "$f" "$newname"
done
echo "Downloading bin boundaries"
#wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/ebins.tar.bz2
#tar -xvjf ebins.tar.bz2
echo "Doing example run to test"
echo "Creating run directory if does not exits"
mkdir -p ${act_home}/run
cd ${act_home}/run
cp ${act_home}/examples_linux/CrW ${act_home}/run/.
cp ${act_home}/examples_linux/tripoli_flux ${act_home}/run/.
echo `../actyslinux <<< "CrW"`


