# call certificate creation script
./certs.sh

# kubectl delete namespace kafka-kraft
kubectl kustomize . | kubectl apply -f -
kubectl scale statefulset kafka --replicas=0
kubectl scale deployment kafka-cli --replicas=0
kubectl scale statefulset kafka --replicas=3
kubectl scale deployment kafka-cli --replicas=1

# delete certificate folder
rm -r ./certs
