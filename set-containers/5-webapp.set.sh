#!/bin/bash
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
# WebAppの起動
##########################################################################################
cd ${WORKDIR}/ut-cadde_gui
git switch testbed

# 環境変数の設定
echo "WebApp用の環境変数を設定"
cp .env .env.local
tgt_path="${WORKDIR}/ut-cadde_gui/.env.local"
echo "    - ${tgt_path}"
sed -i "s|^CLIENT_ID=.*|CLIENT_ID=\"${WEBAPP_CLIENT_ID}\"|" "$tgt_path"
sed -i "s|^CLIENT_SECRET=.*|CLIENT_SECRET=\"${WEBAPP_CLIENT_SECRET}\"|" "$tgt_path"

# WebAppの起動
echo "WebAppを起動しています..."
cd ${WORKDIR}/ut-cadde_gui
docker compose build
docker compose up -d
docker compose ps
echo "WebAppの起動が完了しました。"
