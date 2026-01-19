#!/bin/bash

echo ""
IN_BASHRC=false
if grep -q "export ACTYS_HOME=" ~/.bashrc; then
    IN_BASHRC=true
fi

# CASE 1: Variable is active in environment
if [ -n "$ACTYS_HOME" ]; then
    echo "-----> ACTYS_HOME path is active in current environment: $ACTYS_HOME"
    
    # If active but NOT in bashrc, save it now
    if [ "$IN_BASHRC" = false ]; then
        echo "export ACTYS_HOME=$ACTYS_HOME" >> ~/.bashrc
        echo "-----> ACTYS_HOME Path saved to .bashrc for future sessions."
    else
        echo "-----> ACTYS_HOME Path is already in .bashrc."
    fi  

# CASE 2: Variable is NOT in environment but is in bashrc
elif [ "$IN_BASHRC" = true ]; then
    # Extract the value from bashrc to make it available to the current script
    ACTYS_HOME=$(grep "export ACTYS_HOME=" ~/.bashrc | cut -d'=' -f2 | tr -d '"')
    echo "-----> ACTYS_HOME set from .bashrc: $ACTYS_HOME"
    export ACTYS_HOME=$ACTYS_HOME
    source ~/.bashrc # source the variable for current use

# CASE 3: PATH of PATH variable is not set then ask user for path
else
    echo "--------------> ACTYS_HOME is not defined."
    echo "--------------> Provide ACTYS_HOME variable where ACTYS main folder is located e.g."
    echo ""
    echo "             /home/${USER}/ACTYS         "
    echo ""
    echo "=============> Enter the path for ACTYS_HOME variable" 
    read ACTYS_HOME
        
    echo "export ACTYS_HOME=$ACTYS_HOME" >> ~/.bashrc
    echo "-----> ACTYS_HOME saved to ~/.bashrc"
fi

echo ""
echo "ACTYS_HOME is set to $ACTYS_HOME"
echo ""
echo ""
cd ${ACTYS_HOME}/Data
echo ""


echo "Copying license file to $ACTYS_HOME/Data"
cp $actys_license ${ACTYS_HOME}/Data/.
echo "Downloading EAF2010 libraries"
URL="https://git.oecd-nea.org/fispact/nuclear_data/-/raw/main/EAF2010data.tar.bz2?inline=false"
DATA_ROOT="$ACTYS_HOME/Data"
ARCHIVE_NAME="EAF2010data.tar.bz2"
ARCHIVE_PATH="$DATA_ROOT/$ARCHIVE_NAME"
TARGET_DIR="$DATA_ROOT/EAF2010"

# Ensure directories exist
mkdir -p "$DATA_ROOT"
mkdir -p "$TARGET_DIR"

# --- Spinner Function ---
spinner() {
    local pid=$1
    local msg=$2
    local delay=0.1
    local spinstr='|/-\'
    while kill -0 "$pid" 2>/dev/null; do
        local temp=${spinstr#?}
        printf " [%c]  $msg... " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\r"
    done
    printf " [OK]  $msg finished.               \n"
}

# --- Check for Existing Processed Files ---
echo "    Checking workspace status..."
# Check if at least one 'fus_2010' file exists
if ls "$TARGET_DIR"/*_fus_2010 >/dev/null 2>&1; then
    echo "    Processed files (e.g., eaf_n_gxs_100_fus_2010) already exist."
    echo "    Skipping extraction and renaming."
else
    # --- Download Logic (Only if files don't exist) ---
    if [[ -f "$ARCHIVE_PATH" ]]; then
        echo "    Archive found: $ARCHIVE_PATH."
    else
        echo "    Archive not found. Downloading to $DATA_ROOT..."
        env -i PATH="$PATH" wget --no-check-certificate -L -O "$ARCHIVE_PATH" "$URL"
        if [[ ! -s "$ARCHIVE_PATH" ]]; then
            echo "    Error: Download failed."
            rm -f "$ARCHIVE_PATH"
            exit 1
        fi  
    fi

    # --- Extraction ---
    echo "    Extracting files containing 'fus'..."
    (
        tar -xjf "$ARCHIVE_PATH" -C "$TARGET_DIR" --wildcards "*fus*" --strip-components=1 2>/dev/null || \
        tar -xjf "$ARCHIVE_PATH" -C "$TARGET_DIR" --wildcards "*fus*"
    ) &
    PID=$!
    spinner $PID "Extracting data"

    # --- Renaming Logic ---
    rename_files() {
        cd "$TARGET_DIR" || return
        for file in *fus*; do
            if [[ -f "$file" ]]; then
                suffix="${file##*_}"
                if [[ ${#suffix} -eq 5 && "$suffix" == *0 ]]; then
                    new_name="${file%?}" 
                    mv -f "$file" "$new_name"
                fi
            fi
        done
    }

    echo "    Renaming files for ACTYS usage..."
    rename_files & 
    PID=$!
    spinner $PID "Renaming files"
fi

# --- Final Verification ---
echo "------------------------------------------------"
echo "ACTYS Data Status in $TARGET_DIR:"
ls "$TARGET_DIR" | grep "fus_2010" | head -n 5
sleep 3

echo "------------------------------------------------"
echo "Done! Cross-section libraries are ready in $TARGET_DIR"
# download bind edges
echo "Downloading bin edges"
# Configuration
URL="https://git.oecd-nea.org/fispact/nuclear_data/-/raw/main/ebins.tar.bz2?inline=false"
ARCHIVE_NAME="ebins.tar.bz2"
ARCHIVE_PATH="$DATA_ROOT/$ARCHIVE_NAME"

echo "	Checking for ebins archive in $DATA_ROOT..."

if [[ -f "$ARCHIVE_PATH" ]]; then
    echo "Archive found: $ARCHIVE_PATH. Skipping download."
else
    echo "Archive not found. Downloading to $DATA_ROOT..."
    # env -i PATH="$PATH" bypasses the Anaconda libcurl error
    env -i PATH="$PATH" wget --no-check-certificate -L -O "$ARCHIVE_PATH" "$URL"
    
    if [[ ! -s "$ARCHIVE_PATH" ]]; then
        echo "Error: Download failed or file is empty."
        rm -f "$ARCHIVE_PATH"
        exit 1
    fi  
fi

echo "Step 2: Extracting files into $DATA_ROOT..."
(
		tar -xjf "$ARCHIVE_PATH" -C "$DATA_ROOT"
) &

PID=$!
spinner $PID  "extracting bind edges"

echo "Doing example run to test"
echo "Creating run directory if does not exits"
mkdir -p ${ACTYS_HOME}/run
cd ${ACTYS_HOME}/run
cp ${ACTYS_HOME}/examples_linux/CrW ${ACTYS_HOME}/run/.
cp ${ACTYS_HOME}/examples_linux/tripoli_flux ${ACTYS_HOME}/run/.
# correcting path of example input file
sed -i "2s|.*|$ACTYS_HOME/Data|" CrW
echo "now doing ACTYS run for CrW example input file in run directory"
(
		echo CrW | ../actyslinux
) &

PID=$!
spinner $PID "ACTYS is running"		
sleep 2
echo ""
echo ""
echo "Showing comparison of CrW.out from standard run with run on this system for user $USER"
echo ""
echo "!IMPORTANT "
echo " <<<< If there are significant difference in the output files. Please intimate to the actys@iterindia.in>>>"
sleep 2
echo "Press Alt+F10"
sleep 2
echo "Press enter to show vimdiff comparison"
read *
vimdiff $ACTYS_HOME/run/CrW.out $ACTYS_HOME/examples_linux/CrW.out
echo ""
echo ""
echo "If there are significant difference in the output files. Please intimate to the actys@iterindia.in"
