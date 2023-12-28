### Dependencies


| Technology | Version |
| :--------- | :-----: |
| Minikube   | v1.29.0 |
| cp-kafka   |  7.5.3  |
| Java       |  >=17   |

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

