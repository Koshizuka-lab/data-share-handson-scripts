#!/bin/bash -e
set -e
set -o pipefail
##########################################################################################
# 事前に設定する内容
##########################################################################################
source ../config.env
# 定義されるべき変数が空の場合、終了
[ "$CADDE_USER_ID" = "<CADDEユーザID>" ] || [ "$CADDE_USER_ID" = "" ] && echo "エラー: 環境変数 CADDE_USER_ID が設定されていないか、空文字です。" && exit 1
[ "$CADDE_USER_NUMBER" = "<ユーザ番号>" ] || [ "$CADDE_USER_NUMBER" = "" ] && echo "エラー: 環境変数 CADDE_USER_NUMBER が設定されていないか、空文字です。" && exit 1
[ "$SITE_NAME" = "<サイト名>" ] || [ "$SITE_NAME" = "" ] && echo "エラー: 環境変数 SITE_NAME が設定されていないか、空文字です。" && exit 1
[ "$AUTHZ_CLIENT_ID" = "<認可サーバのクライアントID>" ] || [ "$AUTHZ_CLIENT_ID" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_ID が設定されていないか、空文字です。" && exit 1
[ "$AUTHZ_CLIENT_SECRET" = "<認可サーバのクライアントシークレット>" ] || [ "$AUTHZ_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_SECRET が設定されていないか、空文字です。" && exit 1
[ "$CONSUMER_CLIENT_ID" = "<提供者コネクタのクライアントID>" ] || [ "$CONSUMER_CLIENT_ID" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_ID が設定されていないか、空文字です。" && exit 1
[ "$CONSUMER_CLIENT_SECRET" = "<提供者コネクタのクライアントシークレット>" ] || [ "$CONSUMER_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_SECRET が設定されていないか、空文字です。" && exit 1
[ "$WEBAPP_CLIENT_ID" = "<WebAppのクライアントID>" ] || [ "$WEBAPP_CLIENT_ID" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_ID が設定されていないか、空文字です。" && exit 1
[ "$WEBAPP_CLIENT_SECRET" = "<WebAppのクライアントシークレット>" ] || [ "$WEBAPP_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_SECRET が設定されていないか、空文字です。" && exit 1

# CKANサイトの
source ./data-reg-config.env
[ "$FILENAME" = "<提供データのファイル名>" ] || [ "$FILENAME" = "" ] && echo "エラー: 環境変数 FILENAME が設定されていないか、空文字です。" && exit 1
[ "$CKAN_API_KEY" = "<CAKN APIキー>" ] || [ "$CKAN_API_KEY" = "" ] && echo "エラー: 環境変数 CKAN_API_KEY が設定されていないか、空文字です。" && exit 1
[ "$DATA_ID" = "<リソースID>" ] || [ "$DATA_ID" = "" ] && echo "エラー: 環境変数 DATA_ID が設定されていないか、空文字です。" && exit 1


# 1つ目のサブパート：JSONを作成 -> 一時ファイルに保存
json_request=$(cat <<EOF
{
  "cdldatamodelversion": "2.0",
  "cdleventtype": "Create",
  "dataprovider": "${CADDE_USER_ID}",
  "cdldatatags": [
    {
      "cdluri": "http://data-management.${SITE_NAME}.internal:8080/${FILENAME}"
    }
  ]
}
EOF
)

json_temp_file=$(mktemp)
echo "$json_request" > "$json_temp_file"

# 2つ目のサブパート：原本となるデータファイルの絶対パスを記述
data_file="${WORKDIR}/private-http-server/data/${FILENAME}"
echo ${data_file}
# 原本情報登録リクエスト
curl -v -sS -X POST "http://cadde-provenance-management.koshizukalab.dataspace.internal:3000/v2/eventwithhash" \
-F "request=@$json_temp_file;type=application/json" \
-F "upfile=@$data_file;type=text/plain" \
| jq '.'

json_output=$(curl -v -sS -X POST "http://cadde-provenance-management.koshizukalab.dataspace.internal:3000/v2/eventwithhash" \
-F "request=@$json_temp_file;type=application/json" \
-F "upfile=@$data_file;type=text/plain" \
| jq '.')

echo ${json_output}

EVENT_ID=$(echo "$json_output" | jq -r '.cdleventid')
echo ${EVENT_ID}
echo ${EVENT_ID}
echo ${EVENT_ID}
echo ${EVENT_ID}

# 提供者のCKANカタログサイトにイベントキーを登録
echo "\\提供者のCKANカタログサイトにイベントキーを登録しています..."
echo "    - 来歴管理のEVENT_ID: ${EVENT_ID}"

echo "******************************"
echo 'curl -v -sS -X POST "https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443/api/3/action/resource_patch" \
-H "Authorization: ${CKAN_API_KEY}" \
-d '{"id": "${DATA_ID}", "caddec_resource_id_for_provenance": "${EVENT_ID}"}' \
--cacert "${WORKDIR}/certs/cacert.pem" '

echo "$CKAN_API_KEY"
echo "${WORKDIR}/certs/cacert.pem"
echo "${EVENT_ID}"
echo "${DATA_ID}"

curl -v -sS -X POST "https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443/api/3/action/resource_patch" \
-H "Authorization: ${CKAN_API_KEY}" \
-d "{\"id\": \"${DATA_ID}\", \"caddec_resource_id_for_provenance\": \"${EVENT_ID}\"}" \
--cacert "${WORKDIR}/certs/cacert.pem" \
| jq '.'




