# Otus/KodeKloud

## Lecture 05 otus Introduction with GCP (via KodeKloud Playground)

* Create user account in GCP (use KodeKloud Playground)
* Create instances VM in web-interface and connecting to they via SSH
* Consider the options for connecting to hosts via bastion host and VPN

### Create new branch cloud-bastion in github repository (devops_study_infra)

git checkout -b cloud-bastion

### Login to GCP

1. Login to KodeKloud.

2. Select Playground.

3. Create private tab in browser.
    * copy to private tab link to playground (Ctrl + Shift + N)
    * copy Username
    * copy Password

4. Select country (Georgia in my case).

5. Select a project
    * Select from organization (CLOUDLABSGCPORG2.COM)
    * Select project clgcporg2-116 ![project select](doc/Otus05/2022-08-29-05-29-24.png)
  
6. Select Compute Engine ![Compute Engine](doc/Otus05/2022-08-29-05-30-14.png)

7. After creation select Settings-Metadata-SSH keys ![add ssh-key](doc/Otus05/2022-08-29-05-34-38.png)

8. Create on your Linux/Unix system ssh-key.
    * `ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""`
    * `Private key ~/.ssh/appuser`
    * `Public key ~/.ssh/appuser.pub`

9. Copy content from `~/.ssh/appuser.pub` to our project ![SSH-key insert here](doc/Otus05/2022-08-29-05-39-03.png).
    * If ssh-key in Metadate project, this applies to all VM machines in the project
    * Can be override when creating VM
    * Can be block when creating VM

10. Create default route in VPC network
    * Destination IP 0.0.0.0/0 ![VPC Setting](doc/Otus05/2022-08-30-05-50-31.png)

11. Create firewall rule
    * use your IP address
    * or allow all IP 0.0.0.0/0
    * set rule targets "All instances in the network" ![Targets](doc/Otus05/2022-08-30-06-16-11.png)
    * set protocol tcp port 22
    * save rule
    * QUESTION: How to specify ip address?

12. Create instance VM
    * Hostname: Bastion
    * Region: us-central
    * Machine Type: e2-micro ![setup list](doc/Otus05/2022-08-29-07-25-06.png)
    * Boot disk: Ubuntu - ver. 20.04 (because 22.04 not work with MongoDB at the time of creating this instruction)  ![OS Version](doc/Otus05/2022-08-29-07-26-32.png)
    * Allow HTTP&HTTPS traffic ![HTTP(s) Allow Settings](doc/Otus05/2022-08-30-05-56-40.png)
    * Add network tags `bastion`

13. Open Advanced option and setup networking like on screenshot![NetworkSettings](doc/Otus05/2022-08-29-07-34-10.png)

14. Create VM![VM created](doc/Otus05/2022-08-29-07-46-31.png)
    * Check that your VM appeared in the Firewall rule you created ![firewall list](doc/Otus05/2022-08-30-06-24-02.png)
    * If appeared check ssh connection ![ssh-check](doc/Otus05/2022-08-30-06-20-19.png) you should see the VM terminal

15. try to connect to bastion with terminal linux and using early created ssh key
    * `ssh -i ~/.ssh/appuser appuser@externalIpAddrBastion` ![log](doc/Otus05/2022-08-30-06-28-57.png)

### Second internal-host

1. Create second VM without external network ![external settings](doc/Otus05/2022-08-30-06-35-23.png)

2. Check ![internal host](doc/Otus05/2022-08-30-06-38-31.png)

3. try to connect to bastion (Item 9), and then in bastion terminal try to connect to internal-host
    * if you setup firewall allow only your IP, you need add internal IP your bastion setting in firewall rule or create new firewall rule with this IP address
    * `$ ssh internalIp` ![internal Ip](doc/Otus05/2022-08-30-06-43-55.png)
    * if all right you see "permission denied" ![permission](doc/Otus05/2022-08-30-06-45-10.png)

4. Setup Bastion host for direct connection internal network GCP
    * in localhost (your PC/laptop) setup SSH Forwarding
      * ```$ eval `ssh-agent```
      * `$ ssh-add -L` (check ssh-agent list)
      * `$ ssh-add ~/.ssh/appuser` (add to ssh-agent list your ssh private key)![steps](doc/Otus05/2022-08-30-06-58-46.png)
    * try to connection to internal-host via bastion
      * `$ ssh -i ~/.ssh/appuser -A appuser@bastionIp`
      * `$ ssh internal-host-ip` ![expected terminal log](doc/Otus05/2022-08-30-07-04-03.png)
    * make sure that you are on the right host![check host](doc/Otus05/2022-08-30-07-06-38.png)

5. one-command connection to the internal host ssh -J appuser@bastionIp appuser@internalHostIp

6. add in `~/.ssh/appuser` on your localhost next:
   * before edit, create backup this file
   * change IPAddress to yours
  
   ![ssh-config](doc/Otus05/2022-09-01-12-03-37.png)
  
7. save changes and restart terminal to make the function available

8. try to connect use function-alias `internal` ![aliasConnection](doc/Otus05/2022-09-01-12-06-54.png)

### Create VPN sever for GCP

1. Login to bastion via ssh
2. Create file setupvpn.sh
3. Use text editor and write the following lines to the file

    ```bash

    sudo tee /etc/apt/sources.list.d/pritunl.list << EOF
    deb <http://repo.pritunl.com/stable/apt> focal main
    EOF
    sudo apt --assume-yes install gnupg
    gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 7568D9BB55FF9E5287D586017AE645C0CF8E292A
    gpg --armor --export 7568D9BB55FF9E5287D586017AE645C0CF8E292A | sudo tee /etc/apt/trusted.gpg.d/pritunl.asc
    wget -qO - <https://www.mongodb.org/static/pgp/server-6.0.asc> | sudo apt-key add -
    echo "deb [ arch=amd64,arm64 ] <https://repo.mongodb.org/apt/ubuntu> focal/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.  list
    sudo apt update
    sudo apt install -y mongodb-org pritunl
    sudo systemctl start mongod pritunl
    sudo systemctl enable mongod pritunl

    ```

4. Execute: `sudo bash setupvpn.sh`

5. After execution check service status
    * sudo systemctl status mongod
    * sudo systemctl status pritunl ![check status](doc/Otus05/2022-09-01-13-05-05.png)

6. In your browser open refer
    `https://bastionIPAddress/setup`
7. Ignore warning ![warning](doc/Otus05/2022-09-01-13-07-39.png)
8. Open bastion terminal and execute instruction from pritunl page ![command](doc/Otus05/2022-09-01-13-09-24.png)
9. Copy-paste created key and save ![key](doc/Otus05/2022-09-01-13-12-02.png)
10. Ignore warning
11. Execute in bastion terminal: sudo pritunl default-password
    * copy-paste login and password
    * sign in ![sign in](doc/Otus05/2022-09-01-13-15-32.png)
12. initial setup
    * setup username (test) and password (6214157507237678334670591556762) ![change](doc/Otus05/2022-09-01-13-18-42.png)
    * save

13. Add organization and user (Username: test, pin: 6214157507237678334670591556762 ) ![add org and user](doc/Otus05/2022-09-01-13-21-30.png)
    ![result](doc/Otus05/2022-09-01-13-23-24.png)
14. Create server
    * name - test
    * remember port ![result](doc/Otus05/2022-09-01-13-25-35.png)
15. Attach created organization to server and start server ![start](doc/Otus05/2022-09-01-13-27-33.png)

16. Create firewall rule in VPC Network GCP use tag  `bastion` and this tag to your `bastion` VM   ![VPN](doc/Otus05/2022-09-01-13-33-02.png)
17. Download archive contained *.ovpn ![ovpn](doc/Otus05/2022-09-01-13-38-16.png)
18. In your localhost terminal add config `*.ovpn` to openvpn : `sudo openvpn *.ovpn`

19. Open new terminal and check connection through bastion VPN server. `sudo ssh -i ~/.ssh/appuser appuser@10.128.0.8`

bastion_IP = 35.193.139.136
someinternalhost_IP = 10.128.0.8

### TLS certificate for pritunl

1. use ssh and login to bastion
2. install snapd
3. `sudo snap install core`
4. `sudo snap refresh core`
5. `sudo apt-get remove certbot`
6. `sudo snap install --classic certbot`
7. `sudo ln -s /snap/bin/certbot /usr/bin/certbot`
8. `shutdown your web service sudo systemctl stop pritunl`
9. `sudo certbot certonly --standalone -d BastionIPAddress.nip.io`
10. install created certificate to web application

## Lecture Otus 06 Deploy test application

* Install and setup gcloud with our account
* Create host with gcloud help
* Install ruby on this host
* Instal MongoDB and launch
* Deploy test application, launch and testing
* testapp_IP = 34.168.221.121
* testapp_port = 9292

### Install gcloud

1. `curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-400.0.0-linux-x86_64.tar.gz`
2. extract archive.
3. `sudo bash cd ./google-cloud/install.sh`
4. `gcloud init` (use your project in account GCP)
5. check installation
    * `gcloud auth list`

    * ```bash
        gcloud compute instances create reddit-app\
        boot-disk-size=10GB \
        image-family ubuntu-1804-lts \
        image-project=ubuntu-os-cloud \
        machine-type=g1-small \
        tags puma-server \
        restart-on-failure
        ```

6. Or use actual instruction <https://cloud.google.com/sdk/docs/install-sdk>

### Copy scripts to remote VM instance

in your repo `bash copy_to_vm`

### Install Ruby and Bundler

* `ssh username@hostname` login to target host
  
* `bash /your_repository_root_directory/install_ruby.sh`

### Install mongodb

* `ssh username@hostname` - login to target host

* `bash /your_repository_root_directory/install_mongodb.sh`

### Install application, set dependency and start server

* `ssh username@hostname` login to target host
* `git clone -b monolith https://github.com/express42/reddit.git`
* `cd reddit && bundle install`
* `puma -d`
  
### Install with startup script

your local repository directory
`bash /your_repository_root_directory/startup_script.sh`

## Lecture 07 Otus Creating VM image with Packer help

* prepare your repository
* install packer
* setup Application Default Credentials (ADC)
* create Packer template
* deploy VM instance with custom OS image

### Prepare your repository

* Create new branch `packer-base` from `master` branch
  
    ```bash
    git checkout master
    git checkout -b packer-base
    ```

* create in repository root directory new folder `mkdir config-scripts`
* move the scripts created in Lecture 06 from the root directory to the created folder

### Instal Packer

* install Packer

    ```bash
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt update && sudo apt install packer
    ```

* check installation with command `packer -v`

### Setup ADC

* use commadn ```gcloud auth application-default login``` and link your GCP account to Packer
* follow instruction in terminal
* `gcloud init` use your project in GCP and setup region.

### Create and launch Packer template

1. create folder `packer` in root directory
2. create in folder `packer` file `ubuntu18.json`
3. add to file ubuntu18.json next content

    ```json
    {
        "builders": [
            { // this block is responsible for creating a virtual machine
                "type": "googlecompute",
                "project_id": "clgcporg2-111", // your project name (id) in GCP
                "image_name": "reddit-base-{{timestamp}}",
                "image_family": "reddit-base",
                "source_image_family": "ubuntu-1804-lts",
                "image_storage_locations": ["us-central1"],// the region that was specified during ADC initialization
                "zone": "us-central1-a",
                "ssh_username": "appuser",
                "machine_type": "e2-medium",
                "tags": "puma-server"
            }
        ],
             "provisioners": [
            { //this block launch the scripts, which  installs the software on the virtual machine
                "type": "shell",
                "script": "scripts/deploy.sh",
                "execute_command": "{{.Path}}"
            }
        ]
    }
    ```

4. create folder `scripts` in directory packer, and copy in this catalog `install_ruby.sh` | `install_mongodb.sh` | `deploy_sh` from `config-scripts`
5. in folder `scripts` create file `setup_vpc_gcp-script.sh`, and copy to this file GCP network settings.
6. validate your template `packer validate ./ubuntu18.json`
7. and build the image `packer build ubuntu18.json`
8. after build create VM instance with your custom OS image
    * login to VM `ssh appuser@instance_public_ip`
    * execute next command for launch your web application

    ```bash
    cd reddit && bundle install
    puma -d
    ```

9. to check open in your browser `<instance_public_ip>:9292`
