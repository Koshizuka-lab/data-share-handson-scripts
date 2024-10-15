#!/bin/bash -e
set -e
set -o pipefail
##########################################################################################
# 事前に設定する内容(無し)
##########################################################################################

echo -n "確認したいイベントID: "
read EVENT_ID

# 定義されるべき変数が空の場合、終了
curl -v -sS "http://cadde-provenance-management.koshizukalab.dataspace.internal:3000/v2/lineage/${EVENT_ID}?direction=BOTH&depth=-1" \
| jq '.'

