### Development Environment


| Technology | Version |
| :--------- | :-----: |
| Minikube   | v1.29.0 |
| cp-kafka   |  7.5.3  |
| Java       |  >=17   |

### Running locally

```
minikube start
```

```
chmod a+x *.sh
```

```
./deploy.sh
```

```
./create=topic.sh test
```

```
./produce.sh test test-message
```

```
./consume.sh test
```

