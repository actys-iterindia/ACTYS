# ACTYS

This is version 1.2 of actys code.

User is suggested to first run "first_run.sh" file from ACTYS main directory to set the ACTYS path and download necessary libraries.


![actys homepage](https:iterindia.in/actys)


**ACTYS** is a specialized tool for nuclear data processing and activation analysis.
## 1 Download

ACTYS can be downloaded by doing 
git clone git@github.com:actys-iterindia/ACTYS.git
on Linux system
and a zip file can be downloaded for both (i) Linux and (ii) Windows system.

Unzip the ACTYS files to $HOME folder in Linux and %USERPROFILE% folder in Windows system.
Please check the location by doing
echo $HOME on Linux, and 
echo %USERPROFILE% on Windows system

## 1. Quick Start

### 1.1 On Linux system:
To get started with ACTYS, run the installation script located in ACTYS folder:

```bash

chmod u+x first_run.sh

./first_run_linux.sh

The script 
	1. will check and set variables (ACTYS_HOME) in ~/.bashrc file, 
	2. will link actys binaries i.e. actyslinux in $HOME/bin. 
	3. will download cross-section libraries from oecd repositories.

User need to check ~/.bashrc file for ACTYS_HOME variable path. If it is not there set it manually.

The actyslinux binaries are linked to $HOME/bin folder and can be called from anywhere.
```

### 1.2 On Windows system:
Open cmd and go to ACTYS folder. From there run 'first_run_windows.bat'


## 2. How to run

### 2.1 On Linux system
```text
ACTYS examples are available in examples_linux folder under ACTYS folder.
If user has already completed first_run_linux.sh script, then actyslinux will be in bin path and can be called from any folder. 
It is suggested that user makes run folder and makes input files there along with the flux files. From run folder actyslinux can be called.
If actyslinux is not in path then it can be called by $ACTYS_HOME/actyslinux in the terminal.
```
### 2.2 On Windows system
```text
ACTYS examples are available in examples_windows folder under ACTYS folder.
If user has already completed first_run_windows.bat script, then actyswindows.exe will be in the path variable and can be called from any folder.
It is suggested that user makes run folder and makes input files there along with the flux files. From run directory actyswindows.exe can be called.

If actyswindows.exe is not in path then 
  open cmd
  cd %ACTYS_HOME%, and type actyswindows.exe

```
## 3 Please read ACTYS manual (https://github.com/actys-iterindia/ACTYS/blob/main/ACTYS_EULA.pdf)
```text
For actys usage.

User help can be called from any folder or by 

actyslinux --help for linux
actyswindows.exe --help for windows

or from ACTYS folder (if path is not set correctly). 
   ./actyslinux --help 
   actyswindows.exe --help  
```
## 4. Prerequisites

### 4.1 For linux 
```text
Before installing, ensure you have the following:

    * Linux (Ubuntu/CentOS recommended)

    * wget and tar utilities
	
    * gnuplot

    * Minimum 2GB of free disk space for nuclear libraries
```
### 4.2 For windows
```text
    * Windows 7 and above is required with powershell 2.0 and above.
 
    * gnuplot for windows

```
## 5. Directory structure

```text
ACTYS
├── ACTYS_EULA.pdf 
├── actyslinux 
├── ACTYS_Manual_v1.2.pdf 
├── actyswindows.exe
├── Data
│   ├── actys_license_xx-xx-xx-xx-xx-xx
│   ├── andra
│   ├── attn_mat
│   ├── EAF2010
│   ├── list
│   ├── list2
│   ├── list_ele
│   └── spectrum-actys
├── examples_linux
│   ├── CrW
│   ├── CrW.out
│   ├── CrW.path
│   └── tripoli_flux
├── examples_windows
│   ├── CrW
│   ├── CrW.path
│   └── EU-FW
├── first_run.sh
├── README.md
├── run
```

## 6. License

ACTYS is available for acedemic and research usage. 

Please see the user agreement/license avaialable at 

https://github.com/actys-iterindia/ACTYS/blob/main/ACTYS_EULA.pdf.

User need to email, filled and signed form to actys@iterindia.in to obtain license which is PC specific and non-transferable.


## 7. Help and user feedback

For any help, to add more features or to report any problem, please write to actys@iterindia.in.

## 8. Disclaimer

ACTYS is a free code and provided 'AS IS', without any warranty of any kind, express or implied.

Developer takes no responsibility of any type.

## 9. Permissions

The code must not be used for any commercial purpose.

Any result obtained by using actys to be published as per the agreed terms and conditions in the License Agreement.

# Any publication using ACTYS results must cite following references in the publication.

> 1) Development and validation of ACTYS, an activation analysis code, SC Tadepalli, P Kanth, G Indauliya, I Saikia, SP Deshpande, PV Subhash, Annals of Nuclear Energy 107, 71-81, 2017

> 2) Composition Optimization Strategy Based on Multiple Radiological Responses for Materials in Spatially and Temporally Varying Neutron Fields, Priti Kanth , Sai Chaitanya Tadepalli , P.V. Subhash, Nuclear Fusion, 58 (12), 126019, 2018.

> 3) Nuclear activation studies in fusion systems: new methods and algorithms Ph.D Thesis 2020, Priti Kanth, HBNI Mumbai India.( http://www.hbni.ac.in/phdthesis/engg/ENGG06201504009.pdf) 


