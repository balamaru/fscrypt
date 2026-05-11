# Backup Key ke OpenBao
## 1. Simpan Key ke OpenBao
```sh
# Buat key dalam base64 dan simpan sebagai file
base64 -w 0 key.key > key_base64.txt

# Simpan ke OpenBao
bao kv put secret/storage-encryption/disk01 key_data=@key_base64.txt
```

## 2. Cara Menggunakan Key
```sh
# Ambil key dan konversi ke biner
bao kv get -field=key_data secret/storage-encryption/disk01 | base64 -d > /tmp/key.key

# Coba Unlock filenya
fscrypt unlock /path/to/encrypted/dir --key-file=/tmp/key.key
```