#!/bin/bas
##########################################################################################
# 事前に設定する内容
##########################################################################################
source ../config.env
# 定義されるべき変数が空の場合、終了
[ "$CADDE_USER_ID" = "" ] && echo "エラー: 環境変数 CADDE_USER_ID が空文字です。" && exit 1
[ "$CADDE_USER_NUMBER" = "" ] && echo "エラー: 環境変数 CADDE_USER_NUMBER が空文字です。" && exit 1
[ "$SITE_NAME" = "" ] && echo "エラー: 環境変数 SITE_NAME が空文字です。" && exit 1
[ "$AUTHZ_CLIENT_ID" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_ID が空文字です。" && exit 1
[ "$AUTHZ_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_SECRET が空文字です。" && exit 1
[ "$CONSUMER_CLIENT_ID" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_ID が空文字です。" && exit 1
[ "$CONSUMER_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_SECRET が空文字です。" && exit 1
[ "$WEBAPP_CLIENT_ID" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_ID が空文字です。" && exit 1
[ "$WEBAPP_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_SECRET が空文字です。" && exit 1

##########################################################################################
# Providerの設定ファイルを更新
##########################################################################################
### ブランチの変更
cd ${WORKDIR}/klab-connector-v4/
git switch testbed

### 共通ファイルの展開
cd ${WORKDIR}/klab-connector-v4/src/provider
sh setup.sh

### リバースプロキシの設定
mkdir -p ${WORKDIR}/klab-connector-v4/src/provider/nginx/volumes/ssl
cp ${WORKDIR}/certs/server.key ${WORKDIR}/klab-connector-v4/src/provider/nginx/volumes/ssl/server.key
cp ${WORKDIR}/certs/server.crt ${WORKDIR}/klab-connector-v4/src/provider/nginx/volumes/ssl/server.crt
cp ${WORKDIR}/certs/cacert.pem ${WORKDIR}/klab-connector-v4/src/provider/nginx/volumes/ssl/cacert.pem
ls ${WORKDIR}/klab-connector-v4/src/provider/nginx/volumes/ssl

### データカタログの接続設定
tgt_path=${WORKDIR}/klab-connector-v4/src/provider/connector-main/swagger_server/configs/provider_ckan.json
sed -i "s|<横断検索用カタログサイトURL>|https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443|g" "$tgt_path"
sed -i "s|<詳細検索用カタログサイトURL>|https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443|g" "$tgt_path"

### プライベートHTTPサーバのデフォルトファイルを設定
tgt_path=${WORKDIR}/klab-connector-v4/src/provider/connector-main/swagger_server/configs/http.json
sed -i "s|https://example1.com/data.txt|http://data-management.${SITE_NAME}.internal:8080/authorized.txt|g" "$tgt_path"
sed -i "s|https://example2.com/data.txt|http://data-management.${SITE_NAME}.internal:8080/unauthorized.txt|g" "$tgt_path"

