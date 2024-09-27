curl -v -sS -X POST "https://cadde-catalog-0001.seike.dataspace.internal:8443/api/3/action/resource_patch" \
-H "Authorization: eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJON3lnQXhqZG1IZFlGVjJtM1gtUmxnazBPTzh4cUxyVFJvZHBPbXk1STNFIiwiaWF0IjoxNzI3Mjg2MTU4fQ.-CrHazNj0DTDbFE7g7PAUANz8iOiKae41jeTm3XCQJI" \
-d '{"id": "7315b950-0558-4ce9-acda-566a87e76200", "caddec_resource_id_for_provenance": "2f7e162c-3f6c-4301-be8e-26d474dec08c"}' \
--cacert '/home/seike/cadde_testbed/certs/cacert.pem' \
| jq '.'



