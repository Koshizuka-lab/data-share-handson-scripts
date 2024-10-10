#!/bin/bash -e
set -e
set -o pipefail
##########################################################################################
# 事前に設定する内容
##########################################################################################
EVENT_ID=<原本情報登録イベントID>
[ "$EVENT_ID" = "<原本情報登録イベントID>" ] || [ "$EVENT_ID" = "" ] && echo "エラー: 環境変数 EVENT_ID が設定されていないか、空文字です。" && exit 1

# 定義されるべき変数が空の場合、終了
curl -v -sS "http://cadde-provenance-management.koshizukalab.dataspace.internal:3000/v2/lineage/${EVENT_ID}?direction=BOTH&depth=-1" \
| jq '.'

