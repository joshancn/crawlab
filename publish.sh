
#!/bin/bash

docker build -t crawlablocal:latest .
docker rm -f crawlab_master crawlab_worker1

docker run -d \
    --name crawlab_master \
    -e CRAWLAB_SERVER_MASTER=Y \
    -e CRAWLAB_MONGO_HOST=10.0.10.80 \
    -e CRAWLAB_MONGO_PORT=27017 \
    -e CRAWLAB_MONGO_DB=crawlab \
    -e CRAWLAB_MONGO_USERNAME=crawlab \
    -e CRAWLAB_MONGO_PASSWORD=123456 \
    -e CRAWLAB_MONGO_AUTHSOURCE=crawlab \
    -v /data/crawlab_master/data:/data \
    -v /data/crawlab_master/log:/var/log/crawlab \
    -p 80:8080 \
    -p 9666:9666 \
    crawlablocal:latest

docker run -d \
    --name crawlab_worker1 \
    -e CRAWLAB_NODE_MASTER=N \
    -e CRAWLAB_GRPC_ADDRESS=10.0.10.80:9666 \
    -e CRAWLAB_FS_FILER_URL=http://10.0.10.80:80/api/filer \
    -v /data/crawlab_worker1/meta:/root/.crawlab \
    -v /data/crawlab_worker1/data:/data \
   crawlablocal:latest