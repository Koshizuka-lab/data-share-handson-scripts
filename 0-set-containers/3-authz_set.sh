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
# 提供者認可機能の設定ファイルを更新
##########################################################################################
### 認証機能との連携に関する設定
tgt_path=${WORKDIR}/klab-connector-v4/misc/authorization/settings.json
sed -i "s|<提供者コネクタのクライアントID>|provider-${CADDE_USER_ID}|g" "$tgt_path"
sed -i "s|<認可機能のクライアントID>|${AUTHZ_CLIENT_ID}|g" "$tgt_path"
sed -i "s|<認可機能のクライアントシークレット>|${AUTHZ_CLIENT_SECRET}|g" "$tgt_path"
sed -i "s|<認可機能KeycloakベースURL>|http://cadde-authz-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:5080/keycloak|g" "$tgt_path"
echo "CADDEデータ共有基盤の認証機能(Keycloak)との連携に関する設定を行いました。"
echo "    - ${tgt_path}"

### 認可機能の起動
cd ${WORKDIR}/klab-connector-v4/misc/authorization
echo "認可機能を起動しています..."
sh ./start.sh
docker compose ps
echo "認可機能の起動を完了しました。"

### 認可機能の初期セットアップ
echo "認可機能の初期セットアップを開始します..."
cd ${WORKDIR}/klab-connector-v4/misc/authorization
bash ./provider_setup.sh
