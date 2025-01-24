## Overview

Asymmetric cryptography, uses public and private keys to encrypt and decrypt data.

One key in the pair can be shared with everyone; it is called the public key. <br>
The other key in the pair is kept secret; it called the private key.

### STEP 1 -- Use case of asymmetric key encryption

Either of the keys can be used to encrypt a message;
the opposite key from the one used to encrypt the messaing is used for decryption.

1. Generation of Keys
2. Encryption and Decryption

### STEP 2 -- Use case of asymmetric key encryption

User zeal wants to log in to the server. <br>
Since the server uses a public key authentication, <br>
instead of taking the password from the user, <br>
the server will verify if the User claiming to be zeal actually holds the right private key.

### STEP 3 -- Use case of asymmetric key encryption

Since the user zeal holds the associate private key, he will be able to decrpyt the message and compute the answer, which would be 5. <br>
Then, he will encrypt the message with the private key and send it back to the server.

### STEP 4 -- Use case of asymmetric key encryption

The server decrypts the message with the user's Public Key and checks if the answer is correct. <br>
If yes, then the server will send an Authentication Successful message and the use will be able to log in.

```shell
[root@ip-172-31-62-21 ~] ssh-keygen
[root@ip-172-31-62-21 ~] cd ~/.ssh/
[root@ip-172-31-62-21 .ssh] ls
authorized_keys id_rsa id_rsa.pub

[root@ip-172-31-62-21 .ssh] cat id_rsa.pub
ssh-rsa AAAAB3Nza....

[root@ip-172-31-62-21 .ssh] cat id_rsa
-----BEGIN RSA PRIVATE KEY-----
MITEoA.....
-----END RSA PRIVATE KEY-----
```

Because of the advantage that it offers, `asymmetric key encryption` is used be variety of protocols.

Some of these include:

- PGP
- SSH
- Bitcoin
- TLS
- S/MINE
