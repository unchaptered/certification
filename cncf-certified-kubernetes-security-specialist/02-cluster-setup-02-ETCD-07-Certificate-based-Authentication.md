## Overview of Certificate based authentication

Certificate Based Authentication is used to identify user/device before granting access to a specific resource like website.

### Basic Workflow

While requesting, client needs to also send the certificate that was assigned to him

### Certificate Provisioning

Every user who needs to access the website, will need to have a signed certificate

```shell
curl -k https://54.87.70.138
```

```html
<html>
  <head>
    <title>400 No required SSL certificate was cent</title>
  </head>
  <body bgcolor="white">
    <center><h1>400 Bad Request</h1></center>
    <center>No required SSL certificate was sent</center>
    <hr />
    <center>nginx/1.12.2</center>
  </body>
</html>
```

```shell
curl -k --cert ./client.crt --key ./client.key https://54.87.78.138
```
