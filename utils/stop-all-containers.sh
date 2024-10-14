### 稼働中を含む全Dockerコンテナを停止するスクリプト

### WireGuardの停止
wg-quick down wg0

### HTTPサーバ
cd ${WORKDIR}/private-http-server
docker compose stop

### CKAN
cd ${WORKDIR}/ckan-docker
docker compose stop

### 提供者コネクタ
cd ${WORKDIR}/klab-connector-v4/src/provider
sh ./stop.sh

### 認可サーバ
cd ${WORKDIR}/klab-connector-v4/misc/authorization
sh ./stop.sh

### 利用者コネクタ
cd ${WORKDIR}/klab-connector-v4/src/consumer
sh ./stop.sh

### WebApp
cd ${WORKDIR}/ut-cadde_gui
docker compose down
