#!/bin/bash
# shellcheck disable=SC2034,SC2153,SC2155,SC2164

# Copyright Istio Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

####################################################################################################
# WARNING: THIS IS AN AUTO-GENERATED FILE, DO NOT EDIT. PLEASE MODIFY THE ORIGINAL MARKDOWN FILE:
#          docs/tasks/traffic-management/traffic-shifting/index.md
####################################################################################################
source "content/en/boilerplates/snips/gateway-api-gamma-support.sh"

snip_config_all_v1() {
kubectl apply -f samples/bookinfo/networking/virtual-service-all-v1.yaml
}

snip_gtw_config_all_v1() {
kubectl apply -f samples/bookinfo/gateway-api/route-reviews-v1.yaml
}

snip_config_50_v3() {
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-50-v3.yaml
}

snip_gtw_config_50_v3() {
kubectl apply -f samples/bookinfo/gateway-api/route-reviews-50-v3.yaml
}

snip_verify_config_50_v3() {
kubectl get virtualservice reviews -o yaml
}

! IFS=$'\n' read -r -d '' snip_verify_config_50_v3_out <<\ENDSNIP
apiVersion: networking.istio.io/v1
kind: VirtualService
...
spec:
  hosts:
  - reviews
  http:
  - route:
    - destination:
        host: reviews
        subset: v1
      weight: 50
    - destination:
        host: reviews
        subset: v3
      weight: 50
ENDSNIP

snip_gtw_verify_config_50_v3() {
kubectl get httproute reviews -o yaml
}

! IFS=$'\n' read -r -d '' snip_gtw_verify_config_50_v3_out <<\ENDSNIP
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
...
spec:
  parentRefs:
  - group: ""
    kind: Service
    name: reviews
    port: 9080
  rules:
  - backendRefs:
    - group: ""
      kind: Service
      name: reviews-v1
      port: 9080
      weight: 50
    - group: ""
      kind: Service
      name: reviews-v3
      port: 9080
      weight: 50
    matches:
    - path:
        type: PathPrefix
        value: /
status:
  parents:
  - conditions:
    - lastTransitionTime: "2022-11-10T18:13:43Z"
      message: Route was valid
      observedGeneration: 14
      reason: Accepted
      status: "True"
      type: Accepted
...
ENDSNIP

snip_config_100_v3() {
kubectl apply -f samples/bookinfo/networking/virtual-service-reviews-v3.yaml
}

snip_gtw_config_100_v3() {
kubectl apply -f samples/bookinfo/gateway-api/route-reviews-v3.yaml
}

snip_cleanup() {
kubectl delete -f samples/bookinfo/networking/virtual-service-all-v1.yaml
}

snip_gtw_cleanup() {
kubectl delete httproute reviews
}
