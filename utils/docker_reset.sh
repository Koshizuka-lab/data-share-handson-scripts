# 稼働中を含む全Dockerコンテナを削除するスクリプト
sudo aa-remove-unknown
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm -force $(sudo docker ps -aq)
sudo docker system prune -a
sudo docker volume prune
sudo docker ps -a
sudo docker images -a
sudo docker volume ls
