## OpenID connection

In this approach, an Identity Provider is used for authentication. <br>
API server must trust the identity provider.

### Integrating with API Server

There are various additional configuration needed for API server as part of integration.

| Flag                    | Description                              |
| ----------------------- | ---------------------------------------- |
| `--oidc-issuer-url`     | The URL of the OpenID Issuer             |
| `--oidc-username-claim` | The OpenID claim to use as the user name |
| `--oidc-client-id`      | Client ID for the OpenID connect client  |

```shell
--oidc-issuer-url=https://accounts.google.com     \
--oidc-username-claim=email                       \
--oidc-client-id="UID.apps.googleusercontent.com" \
```

### How does it work

1. Login to the Identity Provider
2. Identity Provider provides access_token, id_token and refresh_token
3. Make use of the id_token with -token flag while making use of kubectl
4. kubectl sends your id_token in a header called Authorization to the API server
5. API serveres take care of verification
