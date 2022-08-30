# Lecture 05 otus Introduction with GCP (via KodeKloud Playground)

* Create user account in GCP (use KodeKloud Playground)
* Create instances VM in web-interface and connecting to they via SSH
* Consider the options for connecting to hosts via bastion host and VPN

## Create new branch cloud-bastion in github repositor (devops_study_infra)

git checkout -b cloud-bastion

## Login to GCP

1. Login to KodeKloude.

2. Select Playground.

3. Create privat tab in browser.
    * copy to private tab link to playground (Ctrl + Shift + N)
    * copy Username
    * copy Password

4. Select country (Georgia in my case).

5. Select a project
    * Select from organization (CLOUDLABSGCPORG2.COM)
    * Select project clgcporg2-116 ![project select](2022-08-29-05-29-24.png)
  
6. Select Compute Engine ![Compute Engine](2022-08-29-05-30-14.png)

7. After creation select Settings-Metadata-SSH keys ![add ssh-key](2022-08-29-05-34-38.png)

8. Create on your Linux/Unix system ssh-key.
    * `ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""`
    * `Private key ~/.ssh/appuser`
    * `Public key ~/.ssh/appuser.pub`

9. Copy content from `~/.ssh/appuser.pub` to our project ![SSH-key insert here](2022-08-29-05-39-03.png).
    * If ssh-key in Metadate project, this applies to all VM machines in the project
    * Can be overriden when creating VM
    * Can be block when creating VM

10. Create default route in VPC network
    * Destination IP 0.0.0.0/0 ![VPC Setting](2022-08-30-05-50-31.png)

11. Create firewall rule
    * use your IP address
    * or allow all IP 0.0.0.0/0
    * set rule targets "All instances in the network" ![Targets](2022-08-30-06-16-11.png)
    * set protocol tcp port 22
    * save rule
    * QUESTION: How to specify ip address?

12. Create instance VM
    * Hostname: Bastion
    * Region: us-central
    * Machine Type: e2-micro ![setup list](2022-08-29-07-25-06.png)
    * Boot disk: Ubuntu - lastversion ![OS Version](2022-08-29-07-26-32.png)
    * Allow HTTP&HTTPS traffic ![HTTP(s) Allow Settings](2022-08-30-05-56-40.png)

13. Open Advanced option and setup networking like on screenshot![NetworkSettings](2022-08-29-07-34-10.png)

14. Create VM![VM created](2022-08-29-07-46-31.png)
    * Check that your VM appeared in the Firewall rule you created ![firewall list](2022-08-30-06-24-02.png)
    * If appeared check ssh connection ![ssh-check](2022-08-30-06-20-19.png) you should see the VM terminal

15. try to connect to bastion with terminal linux and using early created ssh key
    * `ssh -i ~/.ssh/appuser appuser@externalIpAddrBastion` ![log](2022-08-30-06-28-57.png)

## Second internal-host

1. Create second VM without external network ![external settings](2022-08-30-06-35-23.png)

2. Check ![internal host](2022-08-30-06-38-31.png)

3. try to connect to bastion (Item 9), and then in bastion terminal try to connect to internal-host
    * if you setup firewall allow only your IP, you need add internal IP your bastion setting in firewall rule or create new firewall rule with this IP address
    * `$ ssh internalIp` ![internal Ip](2022-08-30-06-43-55.png)
    * if all right you see "permission denied" ![permission](2022-08-30-06-45-10.png)

4. Setup Bastion host for direct connection internalnetwork GCP
    * in localhost (your PC/laptop) setup SSH Forwarding
      * ```$ eval `ssh-agent``
      * `$ ssh-add -L` (check ssh-agent list)
      * `$ ssh-add ~/.ssh/appuser` (add to ssh-agent list your ssh private key)![steps](2022-08-30-06-58-46.png)
    * try to connection to internal-host via bastion
      * `$ ssh -i ~/.ssh/appuser -A appuser@bastionIp`
      * `$ ssh internal-host-ip` ![expected terminal log](2022-08-30-07-04-03.png)
    * make sure that you are on the right host![check host](2022-08-30-07-06-38.png)

5. one-command connection to the internal host ssh -J appuser@bastionIp appuser@internalHostIp

6. create in `~/.zshrc` function
   * before edit "~/.zshrc", create backup this file
   * `nano ~/.zshrc`
   * type text: sshotus () {
eval `ssh-agent`
ssh-add ~/.ssh/appuser
ssh -J appuser@ip-bastion appuser@ip-internal-host
} ![file config](2022-08-31-05-12-25.png)

7. save changes and restart terminal to make the function avalible

8. try to connect use function-alias `sshotus` ![sshotus](2022-08-31-05-05-49.png)
