#!/bin/sh

pushd ..

#----------------------------------------- ExtAuth -----------------------------------------

kubectl apply -f policies/opa/oauth-scope-apiproduct-opa-cm.yaml
kubectl apply -f policies/extauth/oauth-oidc-atv-authconfig.yaml

#----------------------------------------- Tracks API Product -----------------------------------------

kubectl create namespace tracks --dry-run=client -o yaml | kubectl apply -f -

printf "\nLabel tracks namespace ...\n"
kubectl label namespaces tracks --overwrite shared-gateway-access="true"

kubectl apply -f policies/oidc-atv-routeoption.yaml

printf "\nDeploy Tracks service ...\n"
kubectl apply -f apis/tracks/tracks-api-1.0.yaml
printf "\nDeploy the Tracks HTTPRoute (delegatee) and the HTTP APIProduct ...\n"
kubectl apply -f apiproduct/tracks/tracks-apiproduct-httproute.yaml
kubectl apply -f apiproduct/tracks/tracks-apiproduct.yaml
kubectl apply -f referencegrant/tracks-ns/portal-tracks-apiproduct-reference-grant.yaml


#----------------------------------------- api.example.com route -----------------------------------------

# Label the default namespace, so the gateway will accept the HTTPRoute from that namespace.
printf "\nLabel default namespace ...\n"
kubectl label namespaces default --overwrite shared-gateway-access="true"

printf "\nDeploy the HTTPRoute ...\n"
kubectl apply -f routes/api-example-com-root-httproute.yaml

#----------------------------------------- Portal -----------------------------------------

kubectl apply -f referencegrant/gloo-system-ns/httproute-portal-reference-grant.yaml
kubectl apply -f referencegrant/gloo-system-ns/portal-reference-grant.yaml

kubectl apply -f portal/portal.yaml
kubectl apply -f portal/portal-frontend.yaml

kubectl apply -f policies/portal-cors-route-option.yaml

kubectl apply -f routes/portal-server-httproute.yaml

popd

