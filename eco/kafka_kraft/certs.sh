# Reference: https://github.com/RedHatInsights/patchman-engine/blob/1c0dd895639f89f0394757288541c6d42f35e959/dev/kafka/secrets/create_certs.sh

mkdir -p ./certs

cd certs

# 1. Create own private Certificate Authority (CA)
openssl req -new -newkey rsa:4096 -days 10000 -x509 -subj "/CN=CA" -keyout ca.key -out ca.crt -nodes

# 2. Create kafka server certificate and store in keystore
openssl req -new -newkey rsa:4096 -days 10000 -x509 -subj "/CN=kafka" -addext "subjectAltName = DNS:kafka-0.kafka-headless.kafka-kraft.svc.cluster.local,DNS:kafka-1.kafka-headless.kafka-kraft.svc.cluster.local,DNS:kafka-2.kafka-headless.kafka-kraft.svc.cluster.local,DNS:localhost" \
        -keyout kafka.key -out kafka.crt -nodes
openssl pkcs12 -export -in kafka.crt -inkey kafka.key -out kafka.p12 -password pass:confluent
rm -f kafka.keystore.jks
keytool -importkeystore -destkeystore kafka.keystore.jks -deststorepass confluent -destkeypass confluent -deststoretype pkcs12 -destalias mykey \
        -srcstorepass confluent -srckeystore kafka.p12 -srcstoretype pkcs12 -srcalias 1 -noprompt
# verify certificate
keytool -list -v -keystore kafka.keystore.jks -storepass confluent

# 3. Create Certificate signed request (CSR)
keytool -keystore kafka.keystore.jks -certreq -file kafka.csr -storepass confluent -keypass confluent

# 4. Get CSR Signed with the CA:
echo "subjectAltName = DNS:kafka-0.kafka-headless.kafka-kraft.svc.cluster.local,DNS:kafka-1.kafka-headless.kafka-kraft.svc.cluster.local,DNS:kafka-2.kafka-headless.kafka-kraft.svc.cluster.local,DNS:localhost" > san.cnf
openssl x509 -req -CA ca.crt -CAkey ca.key -in kafka.csr -out kafka-signed.crt -days 10000 -CAcreateserial -passin pass:confluent -extfile san.cnf
# verify certificate
keytool -printcert -v -file kafka-signed.crt -storepass confluent

# 5. Import CA certificate in KeyStore:
keytool -keystore kafka.keystore.jks -alias CARoot -import -file ca.crt -storepass confluent -keypass confluent -noprompt

# 6. Import Signed CSR In KeyStore:
keytool -keystore kafka.keystore.jks -import -file kafka-signed.crt -storepass confluent -keypass confluent -noprompt

# 7. Import CA certificate In TrustStore:
rm -f kafka.truststore.jks
keytool -keystore kafka.truststore.jks -alias CARoot -import -file ca.crt -storepass confluent -keypass confluent -noprompt

rm -f ca.{key,srl} kafka.{crt,csr,key,p12} kafka-signed.crt san.cnf

echo "confluence" > ./jks_pass

cd ..