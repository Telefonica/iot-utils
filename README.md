# General utilities

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
- Install following software:
Launch:
```
sudo yum install dialog git -y
sudo yum install sshpass -y
sudo yum install openconnect -y
# A program for making large letters out of ordinary text
sudo yum install figlet -y
```
- Install Ansible and OST python clients in system python environment (not recommended)
```
# Ansible 2.0 version
ANSIBLE_VERSION=2.0.2.0
WINRM_VERSION=0.1.1

# Install Ansible package
pip install ansible==${ANSIBLE_VERSION}

# Install WIN RM for work with Windows machines
pip install pywinrm==${WINRM_VERSION}

# Install OpenStack client tools
pip install python-cinderclient==1.4.0
pip install python-glanceclient==1.1.0
pip install python-keystoneclient==1.7.2
pip install python-neutronclient==3.1.0
pip install python-novaclient==2.30.1
pip install python-openstackclient==1.7.2
```
- Install Ansible and OST python clients in virtual python environments (recommended)
```
yum install virtualenv
# Ansible 1.9 version
ANSIBLE_VERSION=1.9.6
WINRM_VERSION=0.1.1

# Ansible 2.0 version
ANSIBLE_VERSION=2.0.2.0
WINRM_VERSION=0.1.1

# Ansible 2.1 version
ANSIBLE_VERSION=2.1.1.0
WINRM_VERSION=0.2.0

virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
source ~/venv-ansible-${ANSIBLE_VERSION}/bin/activate
# Install Ansible package
pip install ansible==${ANSIBLE_VERSION}

# Install WIN RM for work with Windows machines
pip install pywinrm==${WINRM_VERSION}

# Install OpenStack client tools
pip install python-cinderclient==1.4.0
pip install python-glanceclient==1.1.0
pip install python-keystoneclient==1.7.2
pip install python-neutronclient==3.1.0
pip install python-novaclient==2.30.1
pip install python-openstackclient==1.7.2
```
- Install Ansible and OST python clients from requirements file. Create a file requirements.txt as follows:
```
ansible==2.1.1.0
appdirs==1.4.0
Babel==2.3.4
cffi==1.7.0
cliff==2.2.0
cliff-tablib==2.0
cmd2==0.6.8
cryptography==1.5
debtcollector==1.8.0
enum34==1.1.6
funcsigs==1.0.2
functools32==3.2.3.post2
idna==2.1
ipaddress==1.0.16
iso8601==0.1.11
Jinja2==2.8
jsonpatch==1.14
jsonpointer==1.10
jsonschema==2.5.1
keystoneauth1==2.12.1
MarkupSafe==0.23
monotonic==1.2
msgpack-python==0.4.8
netaddr==0.7.18
netifaces==0.10.5
os-client-config==1.21.0
oslo.config==3.17.0
oslo.i18n==3.9.0
oslo.serialization==2.13.0
oslo.utils==3.16.0
paramiko==2.0.2
pbr==1.10.0
positional==1.1.1
prettytable==0.7.2
pyasn1==0.1.9
pycparser==2.14
pycrypto==2.6.1
pyparsing==2.1.8
python-cinderclient==1.4.0
python-glanceclient==1.1.0
python-keystoneclient==1.7.2
python-neutronclient==3.1.0
python-novaclient==2.30.1
python-ntlm3==1.0.2
python-openstackclient==1.7.2
pytz==2016.6.1
pywinrm==0.2.0
PyYAML==3.12
requests==2.11.1
requests-ntlm==0.3.0
requestsexceptions==1.1.3
rfc3986==0.4.1
simplejson==3.8.2
six==1.10.0
stevedore==1.17.1
tablib==0.11.2
unicodecsv==0.14.1
warlock==1.3.0
wrapt==1.10.8
xmltodict==0.10.2
```
Launch:
```
pip install -r requirements.txt
```
And for PyCharm, as no root user:
```
mkdir -p $HOME/software
cd $HOME/software
wget https://download.jetbrains.com/python/pycharm-community-5.0.4.tar.gz
cd $HOME
tar xvfz software/xvfz pycharm-community-5.0.4.tar.gz
```

### 1.2.- Fix Ansible bug https://github.com/ansible/ansible/issues/14438 for Ansible 2.0.2.0
The problem: If a role is skipped due to failed conditional, the role's dependencies are skipped in subsequent calls

####1.2.1.- Apply the [ansible.patch14438](patchs/ansible.patch14438.patch)
- Test python version and location that you used
```
python --version
which python
```
- Test Ansible version (check that is 2.0.2.0)
```
ansible --version
```
- Download
```
cd <anydirectory>
wget -N https://raw.github.com/Telefonica/iot-utils/develop/patchs/ansible.patch14438.patch
```
- Apply patch automatically (one option)
```
cd $(python -c 'import os; import importlib; module = importlib.import_module("ansible"); print os.path.dirname(module.__file__)')
sudo patch -p0 < <anydirectory>/ansible.patch14438.patch
```
- Apply patch manually (other option)
```
cd $(python -c 'import os; import importlib; module = importlib.import_module("ansible"); print os.path.dirname(module.__file__)')
Edit the file playbook/block.py and delete the lines specified in the patch file (from line 271, delete three lines)
Edit the file playbook/role/__init__.py and delete the lines specified in the patch file (from line 118, delete ten lines)
```

### 1.2.- Howto install
Launch:
```
cd $HOME
git clone git@github.com:Telefonica/iot-utils.git
cp -rp iot-utils/myenvironments $HOME
cp -rp iot-utils/tools $HOME
rm -rf iot-utils
```

### 1.3.- Configure
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

### 1.4.- Start and howto use

#### 1.4.1.- Generate host lists of VMWARE environments (VMWARE envs only useful specific for IOT, not use for others)
Launch:
`noostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvNOOST_*.hosts`
#### 1.4.2.- Generate host lists of OST environments
Launch:
`ostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvOST_*.hosts`

#### 1.4.3.- Use of SSH access to hosts
Launch:
`sshaccess.sh`

#### 1.4.4.- Manually configure openstack environments
- For EPG launch (Selecting desired tenant, and green color):
  ```. openstackenvEPG.sh```
- For PREDSN launch (blue color):
  ```. openstackenvPREDSN.sh```
- For PRODSN launch (red color... Warning!!!):
  ```. openstackenvPRODSN.sh```
- Clear current environment:
  ```. openstackenvCLEAR.sh```

### 1.4.5.- Manage VPNs
To manage VPNs we can use vpnconnect.sh. Howto use and help, launch: `vpnconnect.sh` whitout parameters

### 1.4.6.- Use PyCharm IDE
The first time we need to execute PyCharm IDE from startup script (as no root user):
```
cd $HOME/pycharm-community-5.0.4/bin
./pycharm.sh
```
After, we close PyCharm IDE, and automatically PyCharm IDe creates a desktop menu launch at `Application->Programming->Pycharm Community Edition`


## 2.- Tools
We have tools for work better. These tools are not robust (by now), then you need to modify it to work properly (Ex. paths).

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

### 3.1.- Microsoft has finally integrated into Windows openssh. To install it, follow the steps:

- Download a copy of Win-OpenSSH from https://github.com/PowerShell/Win32-OpenSSH.<br>The last is here: https://github.com/PowerShell/Win32-OpenSSH/releases/download/4_5_2016/OpenSSH-Win64.zip

- Unzip inside folder C:\openssh

- Open a PowerShell console with administrator privileges

- Generate server keys with
```
cd C:\openssh
.\ssh-keygen.exe -A
```

- If Windows Firewall is activated:
Open a port for the SSH server in Windows Firewall:
Either run the following PowerShell command (Windows 8 and 2012 or newer only), as the Administrator:
```
New-NetFirewallRule -Protocol TCP -LocalPort 22 -Direction Inbound -Action Allow -DisplayName SSHD
```
or go to Control Panel > System and Security > Windows Firewall > Advanced Settings > Inbound Rules and add a new rule for port 22.

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
Start the service and/or configure automatic start:
Go to Control Panel > System and Security > Administrative Tools and open Services. Locate SSHD service.
If you want the server to start automatically when your machine is started: Go to Action > Properties. In the Properties dialog, change Startup type to Automatic and confirm.
Start the SSHD service by clicking the Start the service.

- In your Windows account profile folder (typically in C:\Users\username\.ssh)
Create the .ssh folder (for the authorized_keys file) in your Windows account profile folder (typically in C:\Users\username\.ssh).
Do not change permissions for the .ssh and the authorized_keys.
Configure authorized_keys file and store the PEM file in .ssh folder.

- Test ssh connection
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
Inside iot-utils/operations we store processes to operate systems.
By now, exists the following:
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


## 6.- Enjoy it...

