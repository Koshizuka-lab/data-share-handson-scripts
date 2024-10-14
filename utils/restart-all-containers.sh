### 稼働中を含む全Dockerコンテナを停止するスクリプト

### WireGuardの停止
wg-quick up wg0

### HTTPサーバ
cd ${WORKDIR}/private-http-server
docker compose up -d

### CKAN
cd ${WORKDIR}/ckan-docker
docker compose up -d

### 提供者コネクタ
cd ${WORKDIR}/klab-connector-v4/src/provider
sh ./start.sh

### 認可サーバ
cd ${WORKDIR}/klab-connector-v4/misc/authorization
sh ./start.sh

### 利用者コネクタ
cd ${WORKDIR}/klab-connector-v4/src/consumer
sh ./start.sh

### WebApp
cd ${WORKDIR}/ut-cadde_gui
docker compose build
docker compose up -d
