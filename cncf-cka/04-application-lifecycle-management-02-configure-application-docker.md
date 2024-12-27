Args, Commands

CMD는 컨테이너 실행 시점에 전부 재정의 됨.

```Dockerfile
FROM ubuntu

CMD ["sleep", "5"]
```

Basic Run

```shell
docker build -t ubuntu-sleeper .
docker run ubuntu-sleeper # Sleep 5
```

Adv Run with new options

```shell
docker run ubuntu-sleeper sleep 10 # Sleep 10 Seconds

docker run ubuntu-sleeper 10 # Error not found the command of 30
```

ENTRYPOINT는 그렇지 않음

```Dockerfile
FROM ubuntu

ENTRYPOINT ["sleep"]
```

```shell
docker build -t ubuntu-sleeper .
docker run ubuntu-sleeper           # Error!
docker run ubuntu-sleeper 30        # Sleep 30 seconds
docker run ubuntu-sleeper sleep 20  # Error
```

ENTRYPOINT,CMD를 사용하여 안정성을 높일 수 있음

```Dockerfile
FROM ubuntu

ENTRYPOINT ["sleep"]
CMD ["30"]
```

```shell
docker build -t ubuntu-sleepr

docker run ubuntu-sleeper          # Sleep 30
docker run ubuntu-sleeper 20       # Sleep 20
docker run ubuntu-sleeper sleep 20 # Error!
```
