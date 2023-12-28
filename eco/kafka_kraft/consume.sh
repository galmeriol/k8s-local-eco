# Read topic name from the command line
topic=$1

if [ -z "$topic" ]; then
    echo "Topic name not provided"
    exit 1
fi

port=32092

# Get the bootstrap server IP from the cluster node

export BOOTSTRAP_SERVER=$(kubectl get nodes -o jsonpath='{ $.items[0].status.addresses[?(@.type=="InternalIP")].address}'):$port

echo "Bootstrap server: $BOOTSTRAP_SERVER"

echo "Reading message on $topic"
kafka-console-consumer --bootstrap-server $BOOTSTRAP_SERVER --topic $topic --group test-consumer --from-beginning