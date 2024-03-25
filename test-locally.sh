kind create cluster
kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/v1.6.0/deploy/longhorn.yaml
ct install --target-branch main --helm-extra-set-args "--set=mq.storageClassName=longhorn --set=dns.storageClassName=longhorn"
