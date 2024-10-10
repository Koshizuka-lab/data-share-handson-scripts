# data-share-handson-scripts
テストベッドTF、CADDE4.0データ共有ハンズオン用のスクリプトファイルを保存するリポジトリ。

## ハンズオン中のトラブルシューティング一覧。

### ERROR [db internal] load metadata for docker.io/library/postgres:12-alpine と表示された時。
　以下のコマンドを実行した後に、再度同じdockerコマンドを実行する

```
docker pull docker.io/library/postgres:12-alpine
```

### CKANのBuild時のエラー

```txt
=> ERROR [ckan 2/4] RUN mkdir /docker-entrypoint.d
```
　上記エラー出た場合、Dockerの再起動を下記コマンドで実行すると良い。

```bash
sudo systemctl restart docker
```


### 現在のユーザをDockerグループに追加

```
sudo usermod -aG docker $USER
newgrp docker
```