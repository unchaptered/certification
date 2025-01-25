### X509 Client Certificates

A request is authenticated if the client certificate is signed by one of the certificate authorities that is configured in the API server.

---

The private key is stored on an insecure media (local disk storage)

Certificates are generally long-lived. <br>
Kubernetes does not support certificate revocation related area.

Groups are associated with Organization in certificate. <br>
If you want to change the gropu, you will have to issue a new certificate.
