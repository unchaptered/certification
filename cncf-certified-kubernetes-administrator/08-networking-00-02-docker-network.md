docker run --network none -d -p 80:80 --name nginx_no_host nginx

docker run --network host -d -p 80:80 --name nginx_host nginx

docker run --network bridge -d -p 80:80 --name nginx_bridge nginx

<img src="image-4.png" style="width: 300px;" alt="docker network none" />
<img src="image-5.png" style="width: 300px;" alt="docker network host" />
<img src="image-6.png" style="width: 300px;" alt="docker network bridge" />
