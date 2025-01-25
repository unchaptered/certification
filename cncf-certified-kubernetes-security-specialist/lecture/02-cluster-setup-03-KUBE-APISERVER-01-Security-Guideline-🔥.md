## Understanding the API Server

There are two necessary configuration that are reuiqred at kube-apiserver level:

1. Generate Client Certificates for API Server for Client Authentication with ETCD.
2. Connect API Server with ETCD over HTTPS

### Setting TLS Connections on API Server

API Server communication can contain sensitive data.

It's important to serve only HTTPS traffic.

Important flags.

| Flag                        | Description                                                             |
| --------------------------- | ----------------------------------------------------------------------- |
| `--tls-cert-file string`    | File containing the default x509 certficate for HTTPS                   |
| `--tls-private-file string` | File containing the default x509 privaet key mathcing `--tls-cert-file` |   

### Auditing

`kube-apiserver` performs auditing.

Eacth requests on each stage of its execution generates an event, which is the pre-processed according to a certain policy and written to a bakckend.

It's important to have right set of auditing policy set to capture relevant logs.
