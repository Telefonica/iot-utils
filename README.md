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
# Create python virtual environments
sudo yum install virtualenv -y
# Install NetCat utility for Centos/RH 7 and higher
sudo yum install nmap-ncat -y
# Install NetCat utility for Centos/RH 6 and lower
sudo yum install nc -y
```

### 1.3.- Install Ansible and WinRM
First choose versions

- For Ansible 1.9.6 (obsolete)
```
# Ansible 1.9 version
ANSIBLE_VERSION=1.9.6
WINRM_VERSION=0.1.1
```

- For Ansible 2.0.2.0 (obsolete)
```
# Ansible 2.0.2.0 version
ANSIBLE_VERSION=2.0.2.0
WINRM_VERSION=0.1.1
```

- For Ansible 2.1.1.0 (actual)
```
# Ansible 2.1.1.0 version
ANSIBLE_VERSION=2.1.1.0
WINRM_VERSION=0.2.0
```

Then install software
```
rm -rf ~/venv-ansible-${ANSIBLE_VERSION}
virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
source ~/venv-ansible-${ANSIBLE_VERSION}/bin/activate
# Install Ansible package
pip install ansible==${ANSIBLE_VERSION}
# Install WIN RM for work with Windows machines
pip install pywinrm==${WINRM_VERSION}
```

### 1.4.- Install OpenStack client tools
If we will work inside OST environments, we need to install the OpenStack client tools. We have two options, LIBERTY or KILO. For KILO please use KILO

- Install LIBERTY OpenStack client tools
```
pip install --upgrade python-barbicanclient==3.3.0
pip install --upgrade python-ceilometerclient==1.5.2
pip install --upgrade python-cinderclient==1.4.0
pip install --upgrade python-congressclient==1.2.0
pip install --upgrade python-designateclient==1.5.0
pip install --upgrade python-glanceclient==1.1.1
pip install --upgrade python-heatclient==0.8.1
pip install --upgrade python-ironic-inspector-client==1.2.0
pip install --upgrade python-ironicclient==0.8.2
pip install --upgrade python-keystoneclient==1.7.4
pip install --upgrade python-magnumclient==0.2.1
pip install --upgrade python-manilaclient==1.4.0
pip install --upgrade python-mistralclient==1.1.0
pip install --upgrade python-muranoclient==0.7.3
pip install --upgrade python-neutronclient==3.1.1
pip install --upgrade python-novaclient==2.30.2
pip install --upgrade python-openstackclient==1.7.2
pip install --upgrade python-saharaclient==0.11.1
pip install --upgrade python-swiftclient==2.6.0
pip install --upgrade python-tripleoclient==0.1.1
pip install --upgrade python-troveclient==1.3.0
pip install --upgrade python-zaqarclient==0.2.0
```

- Install KILO OpenStack client tools
```
pip install --upgrade python-barbicanclient==3.0.3
pip install --upgrade python-ceilometerclient==1.1.2
pip install --upgrade python-cinderclient==1.1.3
pip install --upgrade python-designateclient==1.1.1
pip install --upgrade python-glanceclient==0.17.3
pip install --upgrade python-heatclient==0.4.0
pip install --upgrade python-ironicclient==0.5.1
pip install --upgrade python-keystoneclient==1.3.4
pip install --upgrade python-manilaclient==1.1.0
pip install --upgrade python-muranoclient==0.5.10
pip install --upgrade python-neutronclient==2.5.0
# NOTE: Not use 2.23.3 please
pip install --upgrade python-novaclient==2.23.2
pip install --upgrade python-openstackclient==1.0.5
pip install --upgrade python-saharaclient==0.8.0
pip install --upgrade python-swiftclient==2.4.0
pip install --upgrade python-troveclient==1.0.9
```

### 1.5.- Generate python requirements file for backup software versions
We recommend to generate the requirements file of this python environment

- Launch for Ansible 2.1.1.0 and OST Liberty
```
pip freeze > $HOME/requirements-ansible-${ANSIBLE_VERSION}-OST-liberty.txt
```

- List of requirements file for Ansible 2.1.1.0 and OST Liberty
```
cat $HOME/requirements-ansible-2.1.1.0-OST-liberty.txt 
alembic==0.8.8
amqp==1.4.9
ansible==2.1.1.0
anyjson==0.3.3
appdirs==1.4.0
Babel==2.3.4
backports.ssl-match-hostname==3.5.0.1
beautifulsoup4==4.5.1
cachetools==1.1.6
cffi==1.8.2
cliff==2.2.0
cliff-tablib==2.0
cmd2==0.6.8
contextlib2==0.5.4
croniter==0.3.12
cryptography==1.5
debtcollector==1.8.0
decorator==4.0.10
docker-py==1.7.2
dogpile.cache==0.6.2
enum34==1.1.6
eventlet==0.19.0
fasteners==0.14.1
funcsigs==1.0.2
functools32==3.2.3.post2
futures==3.0.5
futurist==0.18.0
greenlet==0.4.10
httplib2==0.9.2
idna==2.1
ipaddress==1.0.17
iso8601==0.1.11
Jinja2==2.8
jsonpatch==1.14
jsonpointer==1.10
jsonschema==2.5.1
keystoneauth1==2.12.1
keystonemiddleware==4.9.0
kombu==3.0.35
logutils==0.3.3
lxml==3.6.4
Mako==1.0.4
MarkupSafe==0.23
mistral==2.0.0
mock==2.0.0
monotonic==1.2
msgpack-python==0.4.8
netaddr==0.7.18
netifaces==0.10.5
networkx==1.11
openstacksdk==0.9.6
os-client-config==1.21.1
os-cloud-config==0.4.1
osc-lib==1.1.0
oslo.concurrency==3.14.0
oslo.config==3.17.0
oslo.context==2.9.0
oslo.db==4.13.3
oslo.i18n==3.9.0
oslo.log==3.16.0
oslo.messaging==5.10.0
oslo.middleware==3.19.0
oslo.serialization==2.13.0
oslo.service==1.16.0
oslo.utils==3.16.0
paramiko==2.0.2
passlib==1.6.5
Paste==2.0.3
PasteDeploy==1.5.2
pbr==1.10.0
pecan==1.1.2
pika==0.10.0
pika-pool==0.1.3
ply==3.9
positional==1.1.1
prettytable==0.7.2
pyasn1==0.1.9
pycadf==2.4.0
pycparser==2.14
pycrypto==2.6.1
pyinotify==0.9.6
pyOpenSSL==16.1.0
pyparsing==2.1.9
python-barbicanclient==4.1.0
python-ceilometerclient==2.6.1
python-cinderclient==1.9.0
python-congressclient==1.2.0
python-dateutil==2.5.3
python-designateclient==1.5.0
python-editor==1.0.1
python-glanceclient==2.5.0
python-heatclient==1.4.0
python-ironic-inspector-client==1.9.0
python-ironicclient==1.7.0
python-keystoneclient==3.5.0
python-magnumclient==0.2.1
python-manilaclient==1.4.0
python-mistralclient==2.1.1
python-muranoclient==0.7.3
python-neutronclient==6.0.0
python-novaclient==6.0.0
python-ntlm3==1.0.2
python-openstackclient==3.2.0
python-saharaclient==0.11.1
python-swiftclient==3.1.0
python-tripleoclient==0.1.1
python-troveclient==1.3.0
python-zaqarclient==0.2.0
pytz==2016.6.1
pywinrm==0.2.0
PyYAML==3.12
repoze.lru==0.6
requests==2.11.1
requests-ntlm==0.3.0
requestsexceptions==1.1.3
retrying==1.3.3
rfc3986==0.4.1
Routes==2.3.1
simplegeneric==0.8.1
simplejson==3.8.2
singledispatch==3.4.0.3
six==1.10.0
SQLAlchemy==1.0.15
sqlalchemy-migrate==0.10.0
sqlparse==0.2.1
stevedore==1.17.1
tablib==0.11.2
Tempita==0.5.2
tooz==1.43.0
tripleo-common==5.0.0
unicodecsv==0.14.1
voluptuous==0.9.3
waitress==1.0.0
warlock==1.2.0
WebOb==1.6.1
websocket-client==0.37.0
WebTest==2.0.23
wrapt==1.10.8
WSME==0.8.0
xmltodict==0.10.2
yaql==1.1.1
```

- To recreate other python virtual environment
```
virtualenv ~/venv-ansible-${ANSIBLE_VERSION}
pip install -r $HOME/requirements-ansible-${ANSIBLE_VERSION}-OST-liberty.txt
```

### 1.6.- Install PyCharm IDE Python develop environment
With no root user
```
mkdir -p $HOME/software
cd $HOME/software
wget https://download.jetbrains.com/python/pycharm-community-5.0.4.tar.gz
cd $HOME
tar xvfz software/xvfz pycharm-community-5.0.4.tar.gz
```

### 1.7.- Fix Ansible bug https://github.com/ansible/ansible/issues/14438 for Ansible 2.0.2.0
The problem: If a role is skipped due to failed conditional, the role's dependencies are skipped in subsequent calls

####1.7.1.- Apply the [ansible.patch14438](patchs/ansible.patch14438.patch)
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

### 1.8.- Howto install myenvironments tools
Launch:
```
cd $HOME
git clone git@github.com:Telefonica/iot-utils.git
cp -rp iot-utils/myenvironments $HOME
cp -rp iot-utils/tools $HOME
rm -rf iot-utils
```

### 1.9.- Configure
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

### 1.10.- Start and howto use

#### 1.10.1.- Generate host lists of VMWARE environments (VMWARE envs only useful specific for IOT, not use for others)
Launch:
`noostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvNOOST_*.hosts`
#### 1.10.2.- Generate host lists of OST environments
Launch:
`ostservers.sh`
The host lists are stored at `$HOME/myenvironments/envs/iotenvOST_*.hosts`

#### 1.10.3.- Use of SSH access to hosts
Launch:
`sshaccess.sh`

#### 1.10.4.- Manually configure openstack environments
- For EPG launch (Selecting desired tenant, and green color):
  ```. openstackenvEPG.sh```
- For PREDSN launch (blue color):
  ```. openstackenvPREDSN.sh```
- For PRODSN launch (red color... Warning!!!):
  ```. openstackenvPRODSN.sh```
- Clear current environment:
  ```. openstackenvCLEAR.sh```

### 1.10.5.- Manage VPNs
To manage VPNs we can use vpnconnect.sh. Howto use and help, launch: `vpnconnect.sh` whitout parameters

### 1.10.6.- Use PyCharm IDE
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

