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
7. After creation select Settings-Metadata-SSH keys ![](2022-08-29-05-34-38.png)
8. Create on your Linux/Unix system ssh-key.
    * ssh-keygen -t rsa -f ~/.ssh/appuser -C appuser -P ""
    * Private key ~/.ssh/appuser
    * Public key ~/.ssh/appuser.pub
9. Copy content from ~/.ssh/appuser.pub to our project ![SSH-key insert here](2022-08-29-05-39-03.png). 
    * If ssh-key in Metadate project, this applies to all VM machines in the project
    * Can be overriden when creating VM
    * Can be block when creating VM
10. Create instance VM
    * Hostname: Bastion
    * Region: us-central
    * Machine Type: e2-micro ![setup list](2022-08-29-07-25-06.png)
    * Boot disk: Ubuntu - lastversion ![OS Version](2022-08-29-07-26-32.png)
11. Open Advanced option and setup networking ![NetworkSettings](2022-08-29-07-34-10.png)
12. Create VM![VM created](2022-08-29-07-46-31.png)
    