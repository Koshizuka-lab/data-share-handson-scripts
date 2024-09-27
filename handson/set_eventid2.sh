curl -v -sS -X POST "https://cadde-catalog-0001.seike.dataspace.internal:8443/api/3/action/resource_patch" \
-H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJON3lnQXhqZG1IZFlGVjJtM1gtUmxnazBPTzh4cUxyVFJvZHBPbXk1STNFIiwiaWF0IjoxNzI3Mjg2MTU4fQ.-CrHazNj0DTDbFE7g7PAUANz8iOiKae41jeTm3XCQJI" \
-d '{"id": "6568eacf-ed00-4538-a395-3a3a313ca7ef", "caddec_resource_id_for_provenance": "55bf6bfe-c0c9-4b4c-bed5-c35106f624ec"}' \
--cacert '/home/seike/cadde_testbed/certs/cacert.pem' \
| jq '.'



