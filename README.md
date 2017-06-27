# General utilities

```bash
rmalliotimages.sh \[--help | --rm [--onlydangling\]
```

## 1.- Easy manage environments hosts access
For easy manage environment hosts access<br>
Needs:
- Memory remember many clusters, environments, hostnames, ips, etc?
- Quickly find a specific hosts to access it
- Dynamic refresh of all existing hosts at the time
- Inspect trace log of large number of hosts finding specific information
- Command utilities information at the time of large number of hosts
- Easy filter groups of hosts (by example name, type, etc)
- Easy VPN access


### 1.1.- Requirements
- No root user for this
- Compatibility for ZSH friends:<br>
  In general, all in this repository is compatible with zsh shell. I known a difference, with zsh, we don't need launch ". command.sh" when we need to execute and load environments, only to run "command.sh" is sufficient.


### 1.2.- Install basic software
Launch:

```
# The git client and dialog window text
sudo yum install dialog git -y
# Use passwords inside scripts
sudo yum install sshpass -y
# Create VPNs
sudo yum install openconnect -y
# A program for making large letters out of ordinary text
sudo yum install figlet -y
# Install NetCat utility for Centos/RH 7 and higher
sudo yum install nmap-ncat -y
# Install NetCat utility for Centos/RH 6 and lower
sudo yum install nc -y

# For use OpenStack clients and Ansible, we have two options:

# Installing RPM packages
# Create python virtual environments
sudo yum install python-virtualenv -y
sudo yum install python-virtualenvwrapper -y

# Or installing Python packages (in system Python)
sudo pip install --upgrade pbr
sudo pip install --upgrade PyYAML
sudo pip install --upgrade virtualenv
sudo pip install --upgrade virtualenvwrapper

# How to update all python packages:
sudo pip list --outdated | sed 's/(.*//g' | xargs -n1 pip install -U
```


### 1.3.- Install Ansible WinRM and OpenStack client tools (Linux)
First choose versions
- For Ansible 2.2.0.0 (actual)

```
# Ansible 2.2.0.0 version
ANSIBLE_VERSION=2.2.0.0
WINRM_VERSION=0.2.1
```

Then install software

```
rm -rf ~/venv-ansible-${ANSIBLE_VERSION}
virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
source ~/venv-ansible-${ANSIBLE_VERSION}/bin/activate
# Update basic Python packages
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade wheel
# Install Ansible package
pip install ansible==${ANSIBLE_VERSION}
# Install WIN RM for work with Windows machines
pip install pywinrm==${WINRM_VERSION}
```

- Install KILO OpenStack client tools<br>
  If we will work inside OST environments, we need to install the OpenStack client tools. We have actually KILO supported.

```
pip install --upgrade python-cinderclient==1.9.0
pip install --upgrade python-glanceclient==2.5.0
pip install --upgrade python-heatclient==1.6.1
pip install --upgrade python-keystoneclient==3.8.0
pip install --upgrade python-neutronclient==6.0.0
pip install --upgrade python-novaclient==6.0.0
pip install --upgrade python-openstackclient==3.4.1
pip install --upgrade python-swiftclient==3.2.0
pip install --upgrade python-designateclient==2.3.0
pip install --upgrade python-ironicclient==1.8.0
pip install --upgrade python-magnumclient==2.3.1
pip install --upgrade python-mistralclient==2.1.2
pip install --upgrade python-troveclient==2.6.0
pip install --upgrade shade==1.13.2
```

- Generate python requirements file for backup software versions<br>
  We recommend to generate the requirements file of this python environment

```
# Ansible 2.2.0.0 version
ANSIBLE_VERSION=2.2.0.0
WINRM_VERSION=0.2.1

pip freeze > $HOME/requirements-ansible-${ANSIBLE_VERSION}-OST-kilo.txt
```

- To recreate other python virtual environment

```
# Ansible 2.2.0.0 version
ANSIBLE_VERSION=2.2.0.0
WINRM_VERSION=0.2.1

virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
pip install -r $HOME/requirements-ansible-${ANSIBLE_VERSION}-OST-kilo.txt
```

- Download requirements file Ansible
[requirements-ansible-2.2.0.0-OST-kilo.txt](myenvironments/conf/requirements-ansible-2.2.0.0-OST-kilo.txt)


### 1.4.- Install Ansible WinRM and OpenStack client tools (Windows with CygWin)
We need to use Python version 2.7.12 and architecture x86. With CygWin we use own Python installation, but we can have a Windows Python installation (https://www.python.org/ftp/python/2.7.12/python-2.7.12.msi)
- Install CygWin: https://cygwin.com/setup-x86_64.exe (mininal install)
- Setup Cygwin64 Terminal ICON<br>
  Check execute this program as Administrator
- Disable access to Windows Python installation<br>
  Enter in a Cygwin64 session

```
echo $'PATH=$(echo $PATH | tr \':\' \'\\n\' | grep -v "/cygdrive/.*/Python27" | paste -sd:)' >> .bash_profile
exit
```

- Install base packages<br>
  Enter in a Cygwin64 session

```
curl https://cygwin.com/setup-x86_64.exe -o setup-x86_64.exe
./setup-x86_64.exe -q --packages python python-devel python-setuptools openssl-devel libffi-devel gcc-g++
exit

# Description packages
# python: Python language interpreter
# python-devel: Python language interpreter
# python-setuptools: Python package management tool
# openssl-devel: A general purpose cryptography toolkit with TLS implementation (development)
# libffi-devel: Portable foreign function interface library
# gcc-g++: GNU Compiler Collection (C++)
```

- Install Python packages<br>
  Enter in a Cygwin64 session

```
easy_install-2.7 pip
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade wheel
pip install virtualenv
exit
```

- Install final software<br>
  Enter in a Cygwin64 session

```
# Information of outdated Python packages
pip list --format=columns --outdated

# Workaround to compile with gcc (u_int header type unknown)
export CFLAGS="-D_DEFAULT_SOURCE"
# Ansible 2.2.0.0 version
ANSIBLE_VERSION=2.2.0.0
WINRM_VERSION=0.2.1

rm -rf ~/venv-ansible-${ANSIBLE_VERSION}
virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
source ~/venv-ansible-${ANSIBLE_VERSION}/bin/activate
pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade wheel
# Install Ansible package
pip install ansible==${ANSIBLE_VERSION}
# Install WIN RM for work with Windows machines
pip install pywinrm==${WINRM_VERSION}

pip install --upgrade python-cinderclient==1.9.0
pip install --upgrade python-glanceclient==2.5.0
pip install --upgrade python-heatclient==1.6.1
pip install --upgrade python-keystoneclient==3.8.0
pip install --upgrade python-neutronclient==6.0.0
pip install --upgrade python-novaclient==6.0.0
pip install --upgrade python-openstackclient==3.4.1
pip install --upgrade python-swiftclient==3.2.0
pip install --upgrade python-designateclient==2.3.0
pip install --upgrade python-ironicclient==1.8.0
pip install --upgrade python-magnumclient==2.3.1
pip install --upgrade python-mistralclient==2.1.2
pip install --upgrade python-troveclient==2.6.0
pip install --upgrade shade==1.13.2

pip freeze > $HOME/requirements-ansible-${ANSIBLE_VERSION}-OST-kilo.txt

# Show list of installed packages
cygcheck -c
```


### 1.5.- Install PyCharm IDE Python develop environment
With no root user

```
mkdir -p $HOME/software
cd $HOME/software
wget https://download.jetbrains.com/python/pycharm-community-5.0.4.tar.gz
cd $HOME
tar xvfz software/xvfz pycharm-community-5.0.4.tar.gz
```


### 1.6.- Howto install myenvironments tools
Launch:

```
cd $HOME
git clone git@github.com:Telefonica/iot-utils.git
cp -rp iot-utils/myenvironments $HOME
cp -rp iot-utils/tools $HOME
rm -rf iot-utils
```

### 1.7.- Configure
Read and apply all related task in: `$HOME/myenvironments/conf`

```
bashrcconfignoroot.cnf.template
configetchosts.info
githubprivateenv.sh.template
howtoconfigpublicprivatekeys.info
listostenvs.cnf.template
sshconfigclientnoroot.template
pycharm.info
vpnconnect.info
```

As final step we need to ensure that all session terminals are close, and open new terminals

### 1.8.- Start and howto use

#### 1.8.1.- Generate host lists of VMWARE environments (VMWARE envs only useful specific for IOT, not use for others)
Launch:
`noostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvNOOST_*.hosts`
#### 1.8.2.- Generate host lists of OST environments
Launch:
`ostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvOST_*.hosts`

#### 1.8.3.- Use of SSH access to hosts
Launch:
`sshaccess.sh`

#### 1.8.4.- Configure openstack environments
Launch:

```
. openstackenv<EPG|DSNAH|PREDSN|PRODSN>.sh
```

Or

```
source openstackenv<EPG|DSNAH|PREDSN|PRODSN>.sh
```

Clear current environment:

```
. openstackenvCLEAR.sh
```

Or

```
source openstackenvCLEAR.sh
```

### 1.8.5.- Manage VPNs
To manage VPNs we can use vpnconnect.sh. Howto use and help, launch: `vpnconnect.sh` without parameters

### 1.8.6.- Use PyCharm IDE
The first time we need to execute PyCharm IDE from startup script (as no root user):

```
cd $HOME/pycharm-community-5.0.4/bin
./pycharm.sh
```

After, we close PyCharm IDE, and automatically PyCharm IDe creates a desktop menu launch at `Application->Programming->Pycharm Community Edition`


## 2.- Tools
We have tools for work better. These tools are not robust (by now), then you need to modify it to work properly (Ex. paths)<br>
Stored at $HOME/tools

```
# Show diffs (Version X.Y.Z and commit number/release number) of RPMs between Git and RPM installed machines
diffrpms/findagentbase.sh
HOWTO USE (now only for iot-agent-base):
cd $HOME/tools/diffrpms
./findagentbase.sh
Example output:
*********************************************************
VERIFYING RPM...
*********************************************************
RPMNAME <iot-agent-base>
BRANCH <release/1.3.1>
VERSION <1.3.1>
GITURLREPO <git@github.com:telefonicaid/fiware-IoTAgent-Cplusplus.git>
SHORTSHA1 <57b0ee1>
NUMCOMMITS <117>
OK: ENV <iotenvOST_EPG_201-IOT-demo.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
OK: ENV <iotenvOST_EPG_201-IOT-demo.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
ERROR: ENV <iotenvOST_EPG_201-IoT-int-ext.hosts> PKG <iot-agent-base> DIFFER: GITREPO 1.3.1.117 VS INSTALLED RPM 1.3.1.115
ERROR: ENV <iotenvOST_EPG_201-IoT-int-ext.hosts> PKG <iot-agent-base> DIFFER: GITREPO 1.3.1.117 VS INSTALLED RPM 1.3.1.115
OK: ENV <iotenvOST_EPG_264-iot-int.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
OK: ENV <iotenvOST_EPG_264-iot-int.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
OK: ENV <iotenvOST_PREDSN_IOT-D.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
OK: ENV <iotenvOST_PREDSN_IOT-D.hosts PKG <iot-agent-base> EQUAL GITREPO VS INSTALLED RPM
UNKNOWN: ENV <iotenvOST_PRODSN_IOT-L.hosts PKG <iot-agent-base> CANNOT ACCESS
UNKNOWN: ENV <iotenvOST_PRODSN_IOT-L.hosts PKG <iot-agent-base> CANNOT ACCESS


# Show diffs of a encrypted file between actual git branch and a commit
ansible-vault-git-diff.sh
# Decrypt encrypted Ansible files
decryptansiblefiles.sh
# Encrypt files to use with Ansible
encryptansiblefiles.sh
# Show differences inside encrypted files of a current git branch and write to diffcreds directory, over git repo directory parent
findcredentialchanges.sh
# Memory processes sum threads
ps_mem.py
# Example:
sudo python ps_mem.py | grep httpd
  4.2 MiB +   6.3 MiB =  10.5 MiB	httpd (6)
# 10.5 Mib per 6 httpd processes
# Update a git repo and decrypt Ansible encrypted files
updateiotansible.sh
```


## 3.- Windows and PowerShell
We can configure any Windows host to easy access with ssh and work with Windows console and PowerShell

### 3.1.- Microsoft has finally integrated into Windows openssh
To install it, follow the steps:

- Download a copy of Win-OpenSSH from https://github.com/PowerShell/Win32-OpenSSH
- The last is here: https://github.com/PowerShell/Win32-OpenSSH/releases/download/4_5_2016/OpenSSH-Win64.zip

- Unzip inside folder C:\openssh

- Open a PowerShell console with administrator privileges

- Generate server keys with

```
cd C:\openssh
.\ssh-keygen.exe -A
```

- If Windows Firewall is activated:
Open a port for the SSH server in Windows Firewall:<br>
Either run the following PowerShell command (Windows 8 and 2012 or newer only), as the Administrator:

```
New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSHD
```

or go to Control Panel > System and Security > Windows Firewall > Advanced Settings > Inbound Rules and add a new rule for port 22.<br>
NOTE: New-NetFirewallRule is for servers only. If you're on a workstation try:

```
netsh advfirewall firewall add rule name='SSH Port' dir=in action=allow protocol=TCP localport=22
```

- If you need key-based authentication, run the following to setup the key-auth package

```
powershell.exe .\install-sshlsa.ps1
Restart-Computer
```

- Edit C:\openssh\sshd_config to configure sftp server:

```
Subsystem sftp C:\openssh\sftp-server.exe
```

- Install SSHD server as service

```
.\sshd.exe install
Start-Service sshd
```

Make the service start on boot (PowerShell):

```
Set-Service sshd -StartupType Automatic
```

Or manually:
- Start the service and/or configure automatic start:
- Go to Control Panel > System and Security > Administrative Tools and open Services. Locate SSHD service.
- If you want the server to start automatically when your machine is started: Go to Action > Properties.
- In the Properties dialog, change Startup type to Automatic and confirm.
- Start the SSHD service by clicking the Start the service.

In your Windows account profile folder (typically in C:\Users\username\.ssh):
- Create the .ssh folder (for the authorized_keys file) in your Windows account profile folder (typically in C:\Users\username\.ssh).
- Do not change permissions for the .ssh and the authorized_keys.
- Configure authorized_keys file and store the PEM file in .ssh folder.

* Test ssh connection

```
Enter in Windows console
ssh user@winmachine
Enter in Powershell console
powershell -File -
```

Example:

```
ssh myuser@caprica.hi.inet
myuser@caprica.hi.inet's password: 
Microsoft Windows [Versi n 6.1.7601]
Copyright (c) 2009 Microsoft Corporation. Reservados todos los derechos.

admin@CAPRICA C:\Users\admin>powershell -File -
PS C:\Users\admin> Get-EventLog -Log "Application"

   Index Time          EntryType   Source                 InstanceID Message                                                                                                                           
   ----- ----          ---------   ------                 ---------- -------                                                                                                                           
  104935 mar 09 16:04  0           Software Protecti...   1073742727 Se detuvo el servicio de protecci n de software....                                                                               
  104934 mar 09 15:59  0           Software Protecti...   1073742726 Se inici  el servicio de protecci n de software....                                                                               
  104933 mar 09 15:59  Information Software Protecti...   1073742827 El servicio de protecci n de software complet  la comprobaci n del estado de licencias....                                        
  104932 mar 09 15:59  Information Software Protecti...   1073742890 Estado de inicializaci n para objetos de servicio....                                                                             
  104931 mar 09 15:59  Information Software Protecti...   1073742724 Se est  iniciando el servicio de protecci n de software....                                                                       
  104930 mar 09 15:59  Information sshd                            0 No se encontr  la descripci n del Id. de evento '0' en el origen 'sshd'. Es posible que el equipo local no tenga la informaci n...
  104929 mar 09 15:59  Information sshd                            0 No se encontr  la descripci n del Id. de evento '0' en el origen 'sshd'. Es posible que el equipo local no tenga la informaci n...
  104928 mar 09 15:56  Information sshd                            0 No se encontr  la descripci n del Id. de evento '0' en el origen 'sshd'. Es posible que el equipo local no tenga la informaci n...
  104927 mar 09 15:56  Information sshd                            0 No se encontr  la descripci n del Id. de evento '0' en el origen 'sshd'. Es posible que el equipo local no tenga la informaci n...
...
PS C:\Users\myuser> exit

myuser@CAPRICA C:\Users\myuser>exit
Connection to caprica.hi.inet closed.
```

### 3.2.- Uninstall Win-OpenSSH
- Start Powershell as Administrator

- Stop the service

```
Stop-Service sshd
```

- Uninstall

```
.\sshd.exe uninstall
powershell .\uninstall-sshlsa.ps1
Restart-Computer
```


## 4.- Operation process
Inside iot-utils/operations we store processes to operate systems. By now, exists the following:

```
bin/changeloglevelnginx.sh
```

- Change (locally, inside a machine with SSH) the level log of nginx server online.
- Help of use:

```
./changeloglevelnginx.sh 
****************************************
NGINX CHANGE LOG LEVEL
****************************************

Usage: changeloglevelnginx.sh <loglevel>
Where loglevel can be:
    emerg: Emergency situations where the system is in an unusable state.
    alert: Severe situation where action is needed promptly.
    crit: Important problems that need to be addressed.
    error: An Error has occurred. Something was unsuccessful.
    warn: Something out of the ordinary happened, but not a cause for concern.
    notice: Something normal, but worth noting has happened.
    info: An informational message that might be nice to know.
    debug: Debugging information that can be useful to pinpoint where a problem is occurring.


For debug level visit http://nginx.org/en/docs/debugging_log.html
```

- Example of use:
./changeloglevelnginx.sh warn

```
****************************************
NGINX CHANGE LOG LEVEL
****************************************
INFO: Change loglevel to <warn> in file </etc/nginx/conf.d/myweb1.conf>
INFO: Change loglevel to <warn> in file </etc/nginx/conf.d/myweb2.conf>
```
 

## 5.- Manage and administer databases
Here we document tools for manage and administer databases

### 5.1.- Manage and administer Postgres databases
Postgres is an object-relational database management system (ORDBMS) with an emphasis on extensibility and standards-compliance

#### 5.1.1.- Troubleshootings
Solutions for Postgres failures

##### 5.1.1.1.- POSTGRES FAILURE missing chunk number 0 in pg_toasts
When appear: hardware failures, cluster failures, and obsoleted Linux Kernels. Steps:
- Stop postgres

- File system repair

```
e2fsck -fp /dev/<device>
```

- Add following line to /var/lib/pgsql/9.3/data/postgresql.conf

```
allow_system_table_mods = on
```

- Enter postgres session in the affected database

```
psql -U postgres db_affected
```

- From the toast table number of the log failed (here is 2619)

```
SELECT relname from pg_class where oid = 2619;
   relname    
--------------
 pg_statistic
(1 row)
```

- Test that this table is failing

```
SELECT count (*) from pg_statistic;
ERROR:  invalid page in block 25 of relation base/16386/12629
```

- Repair:

```
SET zero_damaged_pages = on;
Output:
SET

REINDEX TABLE pg_statistic;
Output:
WARNING:  invalid page in block 25 of relation base/16386/12629; zeroing out page
ERROR:  could not create unique index "pg_statistic_relid_att_inh_index"
DETAIL:  Key (starelid, staattnum, stainherit)=(1259, 1, f) is duplicated.

DELETE from pg_statistic;
Output:
DELETE 443

REINDEX table pg_statistic;
Output:
REINDEX

VACUUM analyze pg_statistic;
Output:
WARNING:  relation "pg_statistic" page 25 is uninitialized --- fixing
WARNING:  relation "pg_toast_2619" page 9 is uninitialized --- fixing
WARNING:  relation "pg_toast_2619" page 10 is uninitialized --- fixing
WARNING:  relation "pg_toast_2619" page 11 is uninitialized --- fixing
VACUUM
```

- Exit session and remove from /var/lib/pgsql/9.3/data/postgresql.conf the parameter added previously

```
allow_system_table_mods = on
```

- Stop and start postgres. Now the database is repaired

- Do yum update to prevent the same error (Steps only for RH/Centos 6.x)

```
yum update -y bind* coreutils* chkconfig* device-mapper* binutils* dracut* elf* fence* kernel* lvm*
```

- Reboot the machine

```
reboot
```

### 5.2.- Manage and administer MongoDB databases
The MongoDB database is a simple no-sql database, oriented to documents using JSON and BSON formats

#### 5.2.1.- Tools for any version of MongoDB
Inside [managemongodb](managemongodb) we have processes to manage many task for MongoDB<br>
These tools are designed to be used by many people: Developers, Dbas, Release Engineers and Support, under the following concepts: extensive use of regexp expressions, high flexibility, high separated modularity functions, easy configuration and low level design (only use MongoDB tools, nodejs software inside MongoDB tools and Bash)<br>
Because this design, at beginning the use of these tools can be complicated and difficult<br>
Because there are bugs in older MongoDB versions 2.x and 3.1.x and 3.2.x (not manage correctly error code status and not manage a lot of special characters, by example the slash "/"), we construct specific process to do backups and restore MongoDB databases with these characteristics<br>
For MongoDB 3.3.x versions and higher these bugs are resolved, and for these versions we will develop better tools

##### 5.2.1.1.- Howto use
The use is simple, given that for each task we have a separated and isolated process.
- We need to configure according to our needs the files inside conf directory. The environment variables are self-explained
- All database backups are stored inside backup folder, as specified by the --backupprefix parameter of backup processes
- All commands are inside bin folder, and the use is self-explained. For howto use and help we can execute any command without parameters


##### 5.2.1.2.- Commands
Here we list all commands that we can use

- listdbs.sh

```
*************************************************
List mongo db names
*************************************************

Usage: listdbs.sh [--help | --alldbs | --db "searchstring"]
```

- listcolls.sh

```
*************************************************
List mongo collection names of a db
*************************************************

Usage: listcolls.sh [--help | --db "dbname" [ --col "searchstring" ] ]
```

- copydb.sh

```
*************************************************
Copy a mongo db
*************************************************

Usage: copydb.sh [--help | --dbfrom "dbsource" --dbto "dbtarget"]
```

- dropdb.sh

```
*************************************************
Drop a mongo db
*************************************************

Usage: dropdb.sh [--help | --db "dbname"]
```

- rencolls.sh

```
*************************************************
Rename collection names of a mongo db
*************************************************

Usage: rencolls.sh [--help | --db "dbname" --find "searchstring" --replace "replacestring" [ --dochanges ] ]
Where searchstring can be a regexp, and replacepattern is a string to replace the pattern
Examples:

- Find collections that start with sth_ and next char not /, and replace by sth_/
  rencolls.sh --db mydbname --find '^sth_(([^/])|$)' --replace 'sth_\/\1' --dochanges
- Find collections that start with sth_/ and next any char and replace by sth_
  rencolls.sh --db mydbname --find '^sth_\/' --replace 'sth_' --dochanges

- Find collections that start with sth_ and next char not /, and TRY replace by sth_/ (don't apply any changes)
  rencolls.sh --db mydbname --find '^sth_(([^/])|$)' --replace 'sth_\/\1'
- Find collections that start with sth_/ and next any char and TRY replace by sth_ (don't apply any changes)
  rencolls.sh --db mydbname --find '^sth_\/' --replace 'sth_'
```

- backuponedb.sh

```
*************************************************
Backup a mongo db with BSON format
*************************************************

Usage: backuponedb.sh [--help | --db "dbtobackup" [--backupprefix "prefix" default: default] [--rotate <True|othervalue> default: True]]
```

- backupdbs.sh

```
*************************************************
Backup mongo dbs with BSON format
*************************************************

Usage: backupdbs.sh [--help | --alldbs | --dbs "searchstring" [--backupprefix "prefix" default: default] [--rotate <True|othervalue> default: True]]
```

- restoreonedb.sh

```
*************************************************
Restore a mongo db with BSON format
*************************************************

Usage: restoreonedb.sh [--help | --dirbackup "path_abs_dir_backup" --dbsource "dbsource" [--dbtarget "dbtarget"]]
```

- restoredbs.sh

```
*************************************************
Restore mongo dbs with BSON format
*************************************************

Usage: restoredbs.sh [--help | --dirbackup "path_abs_dir_backup" <--dbs "searchstring" | --alldbs]>
```

- STHbackupdbs.sh (a specific process to backup MongoDB databases with slashes inside collection names)

```
*************************************************
STH backup databases
*************************************************

Usage: STHbackupdbs.sh [--help | --done]
```

- STHrestoreonedb.sh (a specific process to restore a MongoDB database with slashes inside collection names)

```
*************************************************
WARNING: Restore databases is very dangerous...
The original database will be dropped...
*************************************************
Example:
STHrestoreonedb.sh --dirbackup /home/ec2-user/managemongodbs/backups/backupsth --dbbackup Bsth_db --dborigin sth_db
```

##### 5.2.1.3.- One example howto backup all MongoDB databases with slashes
We assume that the MongoDB databases are named as prefix '^sth_'<br>
Then we execute two steps:

- Backup of all databases no '^sth_'

```
./backupdbs.sh  --dbs '^(?!sth_)' --backupprefix backupnosth
```

- Backup of all databases '^sth_'

```
/STHbackupdbs.sh --done
```

#### 5.2.2.- Tools for MongoDB versions 3.3.x and higher
In the future we realize these tools more simple and efficient that current tools


## 6.- Create a virtual machine image for OpenStack
We show step by step howto create a virtual machine image for OpenStack. We will use VirtualBox for this task. This VM is compatible with virtualbox too, except that we need to configure cloud-user with password or ssh public key, or use sysadmin user with password or ssh public key

- Create new machine as:

```
Name: Centos7.3-1611-20170515
Linux RedHat 64 bits
512Mb RAM
1CPU
Hard disk VDI dinamic reserved 20Gb
Bidirectional Share clipboard
Bidirectional Drag and Drop
Uncheck Enable audio
One net adapter:
- Bridge adapter Realtek PCIe GBE Family controller. Promiscuous mode. Allow all
Add CDROM ISO CentOS-7-x86_64-DVD-1611.iso
```

- Start machine

- Data for installer in order:

```
- Language installation process -> Continue

- Network and hostname
NOTE: Configure name distinct as localhost.localdomain. Simple name: centos
Configure
One NIC enp0s3 automatic connected required IPV4
Annotate IP and add to putty for later access

- Date and time
Date Madrid with NTP

- Language support add Español España

- Keyboard add Spanish Castillian and configure to first keyboard

- Installation destination -> Done

- Disable kdump

- Security policy
Apply security policy (by default)

- Minimal installation

- Begin install

- Create user admin
name sysadmin
pass ...
Make this user administrator
groups wheel, adm, systemd-journal
```

- Reboot

- Enter SSH in new machine

```
# DNS utils
yum -y install net-tools bind-utils deltarpm
# Chrony/Chronyd
systemctl enable chronyd.service
systemctl reload-or-restart chronyd.service

# DISABLE/ENABLE to permissive selinux (by now disable)
sed -i 's/^SELINUX=.*$/SELINUX=disabled/g' /etc/selinux/config
setenforce 0

# FIREWALLD disable
systemctl stop firewalld
systemctl disable firewalld
systemctl mask firewalld

# EPEL
yum -y install epel-release

# Yum plugins
yum -y install yum-plugin-remove-with-leaves yum-plugin-ovl yum-utils pv

# OpenStack cloud
yum -y install curl cloud-init cloud-utils-growpart acpid
systemctl enable acpid
systemctl start acpid

# Clean...
yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && rpm -vv --rebuilddb
dd if=/dev/zero | pv | dd of=/bigemptyfile bs=4096k || sync && sleep 1 && sync && rm -rf /bigemptyfile

# Reduce image
VBoxManage modifymedium "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" --compact

# For Centos7-1611, for our particular purposes, we update all packages. We can skip this step for reduce image size
yum -y update

# Clean...
yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && rpm -vv --rebuilddb
dd if=/dev/zero | pv | dd of=/bigemptyfile bs=4096k || sync && sleep 1 && sync && rm -rf /bigemptyfile

# Reduce image
VBoxManage modifymedium "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" --compact

# Create standard net interface
echo 'DEVICE="eth0"
BOOTPROTO="dhcp"
BOOTPROTOv6="dhcp"
ONBOOT="yes"
TYPE="Ethernet"
USERCTL="yes"
PEERDNS="yes"
IPV6INIT="yes"
PERSISTENT_DHCLIENT="1"' > /etc/sysconfig/network-scripts/ifcfg-eth0

rm -f /etc/sysconfig/network-scripts/ifcfg-enp0s3

# Configure correctly the network for good access to OST metadata
echo 'NETWORKING=yes
NOZEROCONF=yes' > /etc/sysconfig/network

# Configure cloud-init
Edit /etc/cloud/cloud.cfg
Replace
---
    name: centos
---
by
---
    name: cloud-user
---
And comment line:
# ssh_pwauth:   0

In cloud_init_modules (After  - ssh)
---
 - resolv-conf
---

# Remove persistent net rules
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules
rm -f /etc/udev/rules.d/70-persistent-ipoib.rules

# Change grub config
Edit /etc/default/grub and replace by:
GRUB_TIMEOUT=1
GRUB_DISTRIBUTOR="$(sed 's, release .*$,,g' /etc/system-release)"
GRUB_DEFAULT=saved
GRUB_DISABLE_SUBMENU=true
GRUB_TERMINAL="console serial"
GRUB_SERIAL_COMMAND="serial --speed=115200 --unit=0 --word=8 --parity=no --stop=1"
GRUB_CMDLINE_LINUX="crashkernel=auto console=tty0 console=ttyS0,115200n8 vconsole.keymap=es nofb nomodeset vga=791"

# Launch:
grub2-mkconfig -o /boot/grub2/grub.cfg

# Set keymap and model
localectl set-keymap es,us pc105
localectl set-x11-keymap es,us pc105
localectl set-keymap es,us pc105
localectl set-x11-keymap es,us pc105

localectl status
---
   System Locale: LANG=en_US.UTF-8
       VC Keymap: es,us
VC Toggle Keymap: pc105
      X11 Layout: es,us
       X11 Model: pc105
---

# Add sysadmin to /etc/sudoers file
sysadmin ALL=(ALL) NOPASSWD: ALL

# NOTE: If we need to configure sysadmin to use specific public key, add an .ssh/authorized_keys
As root:
mkdir -p /home/sysadmin/.ssh
Create /home/sysadmin/.ssh/authorized_keys
ssh-rsa ...
chmod 700 /home/sysadmin/.ssh
chmod 600 /home/sysadmin/.ssh/*
chown -R sysadmin.sysadmin /home/sysadmin/.ssh

# Remove cloud-init default domainname localdomain
sed -i -e 's/localdomain//g' /usr/lib/python2.7/site-packages/cloudinit/sources/__init__.py
rm -f /usr/lib/python2.7/site-packages/cloudinit/sources/__init__.py[co]

# Clean...
yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && rpm -vv --rebuilddb
dd if=/dev/zero | pv | dd of=/bigemptyfile bs=4096k || sync && sleep 1 && sync && rm -rf /bigemptyfile

# Reduce image
VBoxManage modifymedium "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" --compact

# To enter with sysadmin remotely, after first reboot (cloud-init disable all password autentication for all users)
Edit /etc/ssh/sshd_config
Add:
Match User sysadmin
  PasswordAuthentication yes

reboot

# Enter in the machine and test OK and remove other things
package-cleanup -y --oldkernels --count=1

# When the image is working properly (disable sysadmin access remotely, only for console)
Edit and comment
/etc/ssh/sshd_config
#Match User sysadmin
#  PasswordAuthentication yes

Edit /etc/cloud/cloud.cfg
Uncomment
ssh_pwauth:   0

# Clean cloud-init data created
userdel -r cloud-user
rm -f /etc/sudoers.d/90-cloud-init-users /etc/group- /etc/gshadow- /etc/passwd- /etc/shadow-
rm -rf /var/lib/cloud

# Clean logs
rm -rf /tmp/*
rm -f /var/log/cloud-init*.log
rm -f /var/log/messages*

# Clean
yum clean all && rm -rf /var/lib/yum/yumdb && rm -rf /var/lib/yum/history && rpm -vv --rebuilddb
dd if=/dev/zero | pv | dd of=/bigemptyfile bs=4096k || sync && sleep 5 && sync && rm -rf /bigemptyfile

# Reduce image
VBoxManage modifymedium "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" --compact

# Clean history
rm -f /root/.bash_history
rm -f /home/sysadmin/.bash_history
cat /dev/null > /home/sysadmin/.bash_history && cat /dev/null > /root/.bash_history && history -c

# WARN: Shutdown machine, not reboot......
shutdown -h now

# From outside of VirtualBox (we use Cygwin)

# Reduce image
VBoxManage modifymedium "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" --compact

# Convert your virtual box image to raw format
VBoxManage clonehd "D:\VMs\Centos7.3-1611-20170515\Centos7.3-1611-20170515.vdi" "D:\compartido\Centos7.3-1611-20170515.raw" --format raw

# In other VM with Centos 7 with shared folder "D:\compartido"
yum install kvm qemu-img
yum install libguestfs-tools

# Convert the image to qcow2 format
qemu-img convert -f raw /media/sf_compartido/Centos7.3-1611-20170515.raw -O qcow2 /media/sf_compartido/Centos7.3-1611-20170515.qcow2 && rm -f /media/sf_compartido/Centos7.3-1611-20170515.raw

# For edit images... Skip this if we don't need
# export LIBGUESTFS_BACKEND=direct
Edit /etc/libvirt/qemu.conf
Uncomment user and group root
systemctl start libvirtd
systemctl enable libvirtd
virt-ls -a /media/sf_compartido/CentOS-7-x86_64-GenericCloud-1608.qcow2 -R /lib/systemd/system
guestmount -a /var/lib/libvirt/images/xenserver.qcow2 -m /dev/sda1 /mnt


- Upload to openstack (we use http://telefonica.github.io/iot-utils/)
Goto tenant (with OST client tools in cygwin)
. venv-ansible-2.2.0.0/bin/activate
. openstackEPG.sh
(venv-ansible-2.2.0.0) [admin@caprica ~][...]-[...]$

openstack image create Centos7.3-1611-20170515 --disk-format qcow2 --file "D:\compartido\Centos7.3-1611-20170515.qcow2"
```


## 7.- Enjoy it...

