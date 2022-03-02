docker-compose down
docker images -a | grep "megandil/myapp" | awk '{print $3}' | xargs docker rmi
docker-compose up -d
