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

# 提供者の認可機能によるクライントID/シークレットの定義
PROVIDER_CLIENT_SECRET_BY_AUTHZ=97YxfzkHR3XpyHBXZd5kSzbJAQPtbuxk
[ "PROVIDER_CLIENT_SECRET_BY_AUTHZ" = "<認可機能が発行したクライアントシークレット>" ] && echo "エラー: 認可機能が発行したクライアントシークレットを記載して下さい。" && exit 1


##########################################################################################
# 提供者認可機能の設定ファイルを更新
##########################################################################################
### 提供者コネクタの認可サーバへの接続設定
echo "提供者コネクタの認可サーバへの接続を設定"
tgt_path=${WORKDIR}/klab-connector-v4/src/provider/authorization/swagger_server/configs/authorization.json
echo "    - ${tgt_path}"
sed -i "s|<認可機能アクセスURL>|http://cadde-authz-${CADDE_USER_NUMBER}.${SITE_NAME}.dataspace.internal:5080|g" "$tgt_path"

### 提供者の認可サーバと提供者コネクタの連携
echo "提供者の認可サーバと提供者コネクタの連携を設定"
tgt_path=${WORKDIR}/klab-connector-v4/src/provider/connector-main/swagger_server/configs/connector.json
echo "    - ${tgt_path}"
sed -i "s|<CADDEユーザID>|${CADDE_USER_ID}|g" "$tgt_path"
sed -i "s|<提供者コネクタのクライアントID>|provider-${CADDE_USER_ID}|g" "$tgt_path"
sed -i "s|<提供者コネクタのクライアントシークレット>|${PROVIDER_CLIENT_SECRET_BY_AUTHZ}|g" "$tgt_path"

### 提供者コネクタの再起動
cd ${WORKDIR}/klab-connector-v4/src/provider
echo "認可サーバの設定を反映するため、提供者コネクタを再起動しています..."
sh ./stop.sh
sh ./start.sh
echo "提供者コネクタの再起動が完了しました。"


