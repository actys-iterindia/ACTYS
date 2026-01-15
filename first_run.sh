echo "--------------> Define ACTYS_HOME variable where Data folder is located e.g."
echo ""

echo "             export ACTYS_HOME=/home/ACTYS/Data"
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
wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/EAF2010data.tar.bz2
echo "Doing untar of libraries"
tar -xvjf EAF2010data.tar.bz2
echo "Downloading bin boundaries"
wget https://git.oecd-nea.org/fispact/nuclear_data/-/blob/main/ebins.tar.bz2
tar -xvjf ebins.tar.bz2
echo "Doing example run to test"
cd ${act_home}/run
cp ${act_home}/examples_linux/CrW ${act_home}/run/.
cp ${act_home}/examples_linux/EU-FW ${act_home}/run/.


