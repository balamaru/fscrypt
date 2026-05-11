# How to Setup FSCRYPT on Ubuntu
fscrypt is a high-level tool for the management of Linux native filesystem encryption. fscrypt manages metadata, key generation, key wrapping, PAM integration, and provides a uniform interface for creating and modifying encrypted directories. For a small low-level tool that directly sets policies, see fscryptctl

## 1. Install packages
```sh
sudo apt update
sudo apt install fscrypt
```
## 2. Create Specific Directory
```sh
mkdir -p $HOME/encrypt
cd $HOME/encrypt
```
## 3. Create Virtual Disk
```sh
dd if=/dev/zero of=fs.img bs=1M count=200
```
## 4. Format ext4 + enable encryption
```sh
mkfs.ext4 fs.img
tune2fs -O encrypt fs.img
e2fsck -f fs.img
```
Verify
```sh
tune2fs -l fs.img | grep encrypt
```
## 5. Mount filesystem
```sh
mkdir -p mnt
sudo mount -o loop fs.img mnt
```
## 6. Generate key
```sh
mkdir -p $HOME/encrypt/key
chmod 700 $HOME/encrypt/key

dd if=/dev/urandom of=$HOME/encrypt/key/demo.key bs=32 count=1
```
## 7. Setup fscrypt
```sh
sudo fscrypt setup
sudo fscrypt setup mnt
```
## 8.Lanjut encrypt directory
```sh
mkdir mnt/secret

sudo fscrypt encrypt mnt/secret --key=$HOME/encrypt/key/demo.key 

# (choose 3 - raw_key)
```
Verify
```sh
sudo fscrypt status mnt/secret
```
## 9. (Lazy Way) Lock and Unlock Directory with Style
Maybe some of us (also me) to lazy doing *sudo fscrypt unlock $HOME/encrypt/mnt/secret --key=$HOME/encrypt/key/key.key* then lock it again *sudo fscrypt unlock $HOME/encrypt/mnt/secret*, and how if it was having multiple directory would lock and unlock at time. There is some way do done of it, like
- Load Key to TPM, need another server to doing it
- Using PAM, the directory bind to specific user and will be unlock when user access the server
- Create a simple systemd service, no need spesific user or another server
I would like to use the simple way with systemd way, here the step
- create file at */etc/systemd/system/fscrypt.service*, sample fila can be found [here](files\fscrypt.service)
- change permission to the key *chmod 600 /path/to/key.key*
- run this, command
```sh
sudo systemctl daemon-reload
sudo systemctl enable fscrypt.service

# Start the service when unlocking the directory
sudo systemctl start fscrypt.service

# Stop the service when locking the directory
sudo systemctl stop fscrypt.service
```
- Here step for being more lazy
```sh
echo 'alias lock='sudo systemctl stop fscrypt.service'' >> ~/.bashrc
echo 'alias unlock='sudo systemctl start fscrypt.service'' >> ~/.bashrc
source ~/.bashrc

# To unlock just run
unlock

# To lock just run
lock
```

## Multiple Directory
- create an unlock [script](files\fscrypt-unlock.sh)
- create an lock [script](fscrypt\files\fscrypt-lock.sh)
- change permission to script *sudo chmod +x /usr/local/bin/fscrypt-lock.sh $$ sudo chmod +x /usr/local/bin/fscrypt-unlock.sh*
- create [systemd service](files\fscrypt-mutiple-dir.service)
- doing teh previous step like in single encrypt file

## References
- [FSCrypt Official Repository](https://github.com/google/fscrypt.git)
- [File System Encryption with fscrypt](https://ejaaskel.dev/yocto-hardening-file-system-encryption-with-fscrypt/)