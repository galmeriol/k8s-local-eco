# Desc: Create a topic in Kafka cluster

port=32092

# Get the bootstrap server IP from the cluster node

export BOOTSTRAP_SERVER=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address}'):$port

echo "Bootstrap server: $BOOTSTRAP_SERVER"

topic=$1

if [ -z "$topic" ]; then
    echo "Topic name not provided"
    exit 1
fi

until kafka-topics --create --if-not-exists --topic $topic --partitions 3 --bootstrap-server $BOOTSTRAP_SERVER --  \
    --replication-factor 1; do
      echo "Unable to create topic $topic"
      sleep 1
done

echo "Topic $topic created successfully"