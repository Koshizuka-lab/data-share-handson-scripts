# data-share-handson-scripts
テストベッドTF、CADDE4.0データ共有ハンズオン用のスクリプトファイルを保存するリポジトリ。

## ハンズオン中のトラブルシューティング一覧。

### ERROR [db internal] load metadata for docker.io/library/postgres:12-alpine と表示された時。
　以下のコマンドを実行した後に、再度同じdockerコマンドを実行する

```
docker pull docker.io/library/postgres:12-alpine
```

### 以下を行うとうまく行くときがある
```
sudo systemctl restart docker
```

### 以下の設定をする。

```
sudo usermod -aG docker $USER
newgrp docker
```