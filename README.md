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

pip install ansible
# For work with windows machines
pip install pywinrm
# OpenStack client tools
pip install python-cinderclient
pip install python-glanceclient
pip install python-keystoneclient
pip install python-neutronclient
pip install python-novaclient
pip install python-openstackclient
```
And for PyCharm, as no root user:
```
mkdir -p $HOME/software
cd $HOME/software
wget https://download.jetbrains.com/python/pycharm-community-5.0.4.tar.gz
cd $HOME
tar xvfz software/xvfz pycharm-community-5.0.4.tar.gz
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
# Memory process sum threads
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

- Download a copy of Win-OpenSSH from https://github.com/PowerShell/Win32-OpenSSH. The last is here: https://github.com/PowerShell/Win32-OpenSSH/releases/download/2_25_2016/OpenSSH-Win64.zip

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


## 4.- Enjoy it...

