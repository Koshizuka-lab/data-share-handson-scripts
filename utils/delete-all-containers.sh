# 稼働中を含む全Dockerコンテナ、Volume、イメージを削除するスクリプト
sudo docker stop $(sudo docker ps -a -q)
sudo docker rm -force $(sudo docker ps -aq)
sudo docker system prune -a
sudo docker volume prune
sudo docker ps -a
sudo docker images -a
sudo docker volume ls
