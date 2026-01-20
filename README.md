# ACTYS

This is version 1.2 of actys code.

User is suggested to first run "first_run.sh" file from ACTYS main directory to set the ACTYS path and download necessary libraries.


![actys homepage](https:iterindia.in/actys)


**ACTYS** is a specialized tool for nuclear data processing and activation analysis.


## 1. Quick Start

To get started with ACTYS, run the installation script:

```bash

chmod u+x first_run.sh

./first_run.sh

The script 
	1. will check and set variables (ACTYS_HOME) in ~/.bashrc file, 
	2. will link actys binaries i.e. actyslinux in $HOME/bin. 
	3. will download cross-section libraries from oecd repositories.

User need to check ~/.bashrc file for ACTYS_HOME variable path. If it is not there set it manually.

The actyslinux binaries are linked to $HOME/bin folder and can be called from anywhere.
```

## 2. How to run

ACTYS examples are available in examples_linux folder under ACTYS folder.

Please read ACTYS manual (https://github.com/actys-iterindia/ACTYS/blob/main/ACTYS_EULA.pdf)
For actys usage.

User help can be called by 

actyslinux --help from any folder 

or ./actyslinux --help from ACTYS folder (if path is not set correctly).


## 3. Prerequisites

Before installing, ensure you have the following:

    * Linux (Ubuntu/CentOS recommended)

    * wget and tar utilities

    * Minimum 2GB of free disk space for nuclear libraries


## 4. Directory structure

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

## 5. License

ACTYS is available for acedemic and research usage. 

Please see the user agreement/license avaialable at 

https://github.com/actys-iterindia/ACTYS/blob/main/ACTYS_EULA.pdf.

User need to email, filled and signed form to actys@iterindia.in to obtain license which is PC specific and non-transferable.


## 6. Help and user feedback

For any help, to add more features or to report any problem, please write to actys@iterindia.in.

## 7. Disclaimer

ACTYS is a free code and provided 'AS IS', without any warranty of any kind, express or implied.

Developer takes no responsibility of any type.

## 8. Permissions

The code must not be used for any commercial purpose.

Any result obtained by using actys to be published as per the agreed terms and conditions in the License Agreement.

### Any publication using ACTYS results should includeded followin reference in the publication.

1) Development and validation of ACTYS, an activation analysis code, SC Tadepalli, P Kanth, G Indauliya, I Saikia, SP Deshpande, PV Subhash, Annals of Nuclear Energy 107, 71-81, 2017

> 2) Composition Optimization Strategy Based on Multiple Radiological Responses for Materials in Spatially and Temporally Varying Neutron Fields, Priti Kanth , Sai Chaitanya Tadepalli , P.V. Subhash, Nuclear Fusion, 58 (12), 126019, 2018.

> 3) Nuclear activation studies in fusion systems: new methods and algorithms Ph.D Thesis 2020, Priti Kanth, HBNI Mumbai India.( http://www.hbni.ac.in/phdthesis/engg/ENGG06201504009.pdf) 


