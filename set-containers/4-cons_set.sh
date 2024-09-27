#!/bin/bas
##########################################################################################
# 事前に設定する内容
##########################################################################################
source ../config.env
# 定義されるべき変数に変更がない場合、終了
[ "$CADDE_USER_ID" = "<CADDEユーザID>" ] && echo "エラー: 環境変数 CADDE_USER_ID が空文字です。" && exit 1
[ "$CADDE_USER_NUMBER" = "" ] && echo "エラー: 環境変数 CADDE_USER_NUMBER が空文字です。" && exit 1
[ "$SITE_NAME" = "" ] && echo "エラー: 環境変数 SITE_NAME が空文字です。" && exit 1
[ "$AUTHZ_CLIENT_ID" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_ID が空文字です。" && exit 1
[ "$AUTHZ_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 AUTHZ_CLIENT_SECRET が空文字です。" && exit 1
[ "$CONSUMER_CLIENT_ID" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_ID が空文字です。" && exit 1
[ "$CONSUMER_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 CONSUMER_CLIENT_SECRET が空文字です。" && exit 1
[ "$WEBAPP_CLIENT_ID" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_ID が空文字です。" && exit 1
[ "$WEBAPP_CLIENT_SECRET" = "" ] && echo "エラー: 環境変数 WEBAPP_CLIENT_SECRET が空文字です。" && exit 1

##########################################################################################
# Consumerの設定ファイルを更新
##########################################################################################
### ブランチの変更
cd ${WORKDIR}/klab-connector-v4/
git switch testbed

### 共通ファイルの展開
cd ${WORKDIR}/klab-connector-v4/src/consumer
sh setup.sh

### リバースプロキシの設定
mkdir -p ${WORKDIR}/klab-connector-v4/src/consumer/nginx/volumes/ssl
cp ${WORKDIR}/certs/server.key ${WORKDIR}/klab-connector-v4/src/consumer/nginx/volumes/ssl/server.key
cp ${WORKDIR}/certs/server.crt ${WORKDIR}/klab-connector-v4/src/consumer/nginx/volumes/ssl/server.crt

### フォワードプロキシの設定
mkdir -p ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl
cp ${WORKDIR}/certs/server.key ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl/client.key
cp ${WORKDIR}/certs/server.crt ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl/client.crt
# ファイルの権限の変更
chmod +r ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl/client.key
# SSL Bump用自己署名SSL証明書を作成
cd ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 -keyout squidCA.pem -out squidCA.pem -subj "/C="
# ファイルの権限の変更
chmod +r ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl/squidCA.pem
ls -l ${WORKDIR}/klab-connector-v4/src/consumer/squid/volumes/ssl

### フォワードプロキシの起動と停止
cd ${WORKDIR}/klab-connector-v4/src/consumer/squid
docker pull docker.io/library/alpine:3.16
docker compose -f docker-compose_initial.yml up -d --build
docker compose -f docker-compose_initial.yml ps
# SSL Bumpで用いられるデータベースを初期化
docker exec -it forward-proxy /usr/lib/squid/security_file_certgen -c -s /var/lib/squid/ssl_db -M 20MB
# フォワードプロキシ用コンテナ内部のディレクトリをホストにコピー
docker cp forward-proxy:/var/lib/squid/ssl_db ./volumes/
# フォワードプロキシのコンテナの停止
docker compose -f docker-compose_initial.yml down

### コネクタの認証機能の設定
tgt_path=${WORKDIR}/klab-connector-v4/src/consumer/connector-main/swagger_server/configs/connector.json
sed -i "s|<利用者コネクタのクライアントID>|${CONSUMER_CLIENT_ID}|g" "$tgt_path"
sed -i "s|<利用者コネクタのクライアントシークレット>|${CONSUMER_CLIENT_SECRET}|g" "$tgt_path" 

### 提供者コネクタの接続設定
tgt_path=${WORKDIR}/klab-connector-v4/src/consumer/connector-main/swagger_server/configs/location.json
sed -i "s|handson-site0X|${CADDE_USER_ID}|g" "$tgt_path" 
sed -i "s|https://cadde-provider-handson.site0X.dataspace.internal:443|https://cadde-provider-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:443|g" "$tgt_path"

### ポートフォワーディングの設定変更：1443->443、180->80
tgt_path=${WORKDIR}/klab-connector-v4/src/consumer/docker-compose.yml 
sed -i "s|- 443:443|- 1443:443|g" "$tgt_path"
sed -i "s|- 80:80|- 180:80|g" "$tgt_path"

### 利用者コネクタの起動
cd ${WORKDIR}/klab-connector-v4/src/consumer
sh start.sh
docker compose ps



