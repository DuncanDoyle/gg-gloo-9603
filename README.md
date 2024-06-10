# Gloo Gateway 1.17 - Kubernetes Gateway API

## Installation

Install Gloo Gateway:
```
cd install
./install-gloo-gateway-with-helm.sh
```

> [!NOTE]
> The Gloo Gateway version that will be installed is set in a variable at the top of the `install/install-gloo-edge-enterprise-with-helm.sh` installation script.

Run the setup script:
```
./setup.sh
```

This will install the APIs, APIProducts, AuthConfig, RouteOptions and HTTPRoutes.

When everything has been deployed, you will see the following error on the `Portal` CR:

```
status:
  common:
    State:
      approval: WARNING
      message: 'failed to stitch schema for route tracks-apiproduct.tracks: incorrectly
        configured ext-auth policy: oauth-oidc-atv-auth for portal. Policy must use
        api key auth that specifies either K8SSecretApikeyStorage or LabelSelector,
        or does not specify either of them'
```

And you will notice that the stitched APIDoc is not created for our APIProduct.