## Implementing Encryption

you can associate an encryption key at `kube-apiserver` level so that the data can be encrypted before being stored at the `ETCD`.

---

### Encryption Provider Configuration

The `kube-apiserver` process accepts an arguement `--encryption-provider-config` that controls how API data is encrypted in `etcd`.

```shell
EN
```

```yaml
cat > ecryption-at-rest.yaml <<EOF
---
apiVersion: v1
kind: EncryptionConfig
resources:
    - resources:
        - secrets:
      providers:
        - aescbc:
            keys:
                - name: key
                  secret: ${ENCRYPTION_KEY}
        - identity: {}
EOF
```

---

### Important Pointers

By default, the identity provider is used to protect secrets in etcd, which provides no encryption.

You can make use of KMS provider for additional security.

The older secrets would still be in an unencrypted form.
