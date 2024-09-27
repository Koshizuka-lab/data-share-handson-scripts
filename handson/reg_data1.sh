# 1つ目のサブパート：JSONを作成 -> 一時ファイルに保存
json_request=$(cat <<EOF
{
  "cdldatamodelversion": "2.0",
  "cdleventtype": "Create",
  "dataprovider": "0001-seike",
  "cdldatatags": [
    {
      "cdluri": "http://data-management.seike.internal:8080/authorized.txt"
    }
  ]
}
EOF
)

json_temp_file=$(mktemp)
echo "$json_request" > "$json_temp_file"

# 2つ目のサブパート：原本となるデータファイルの絶対パスを記述
data_file="/home/seike/cadde_testbed/private-http-server/data/authorized.txt"

# 原本情報登録リクエスト
curl -v -sS -X POST "http://cadde-provenance-management.koshizukalab.dataspace.internal:3000/v2/eventwithhash" \
-F "request=@$json_temp_file;type=application/json" \
-F "upfile=@$data_file;type=text/plain" \
| jq '.'
