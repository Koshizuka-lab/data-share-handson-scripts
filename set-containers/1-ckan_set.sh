#!/bin/bash
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
# CKANの設定ファイルを更新
##########################################################################################
### .envの編集
src_path="${WORKDIR}/ckan-docker/.env.example"
tgt_path="${WORKDIR}/ckan-docker/.env"
cp "$src_path" "$tgt_path"
# 'CKAN_SITE_URL=' で始まる行を置き換える
sed -i "s|^CKAN_SITE_URL=.*|CKAN_SITE_URL=https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443|" "$tgt_path"
echo "s|^CKAN_SITE_URL=.*|CKAN_SITE_URL=https://cadde-catalog-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:8443|"
### Dockerfileの編集(バージョン番号)
tgt_path="${WORKDIR}/ckan-docker/ckan/Dockerfile"
echo $tgt_path
sed -i 's|^FROM ckan/ckan-base:.*|FROM ckan/ckan-base:2.10|' "$tgt_path"

### 秘密鍵とサーバ証明書のコピー
cp "${WORKDIR}/certs/server.key" "${WORKDIR}/ckan-docker/nginx/setup/ckan-local.key"
cp "${WORKDIR}/certs/server.crt" "${WORKDIR}/ckan-docker/nginx/setup/ckan-local.crt"

### nginxのDockerfileの編集
cat <<EOL > "${WORKDIR}/ckan-docker/nginx/Dockerfile"
FROM nginx:stable-alpine

ENV NGINX_DIR=/etc/nginx

RUN apk update --no-cache && \\
    apk upgrade --no-cache && \\
    apk add --no-cache openssl

COPY setup/nginx.conf \${NGINX_DIR}/nginx.conf
COPY setup/index.html /usr/share/nginx/html/index.html
COPY setup/default.conf \${NGINX_DIR}/conf.d/

RUN mkdir -p \${NGINX_DIR}/certs

COPY setup/ckan-local.crt \${NGINX_DIR}/certs/ckan-local.crt
COPY setup/ckan-local.key \${NGINX_DIR}/certs/ckan-local.key

ENTRYPOINT nginx -g 'daemon off;'
EOL

