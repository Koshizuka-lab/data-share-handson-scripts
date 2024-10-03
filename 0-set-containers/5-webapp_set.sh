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

##########################################################################################
# WebAppの起動
##########################################################################################
cd ${WORKDIR}/ut-cadde_gui
git switch testbed

# 環境変数の設定
cp .env .env.local
tgt_path="${WORKDIR}/ut-cadde_gui/.env.local"
sed -i "s|^CLIENT_ID=.*|CLIENT_ID=\"${WEBAPP_CLIENT_ID}\"|" "$tgt_path"
sed -i "s|^CLIENT_SECRET=.*|CLIENT_SECRET=\"${WEBAPP_CLIENT_SECRET}\"|" "$tgt_path"
echo "WebApp用の環境変数を設定しました。"
echo "    - ${tgt_path}"

# WebAppの起動
echo "WebAppを起動しています..."
cd ${WORKDIR}/ut-cadde_gui
docker pull docker.io/library/node:18.12-alpine
docker compose build
docker compose up -d
docker compose ps
echo "WebAppの起動が完了しました。"
