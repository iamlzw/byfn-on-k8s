#!/bin/sh
kubectl apply -f byfn-namespace.yaml
kubectl apply -f byfn-storage.yaml
kubectl apply -f orderer.yaml
kubectl apply -f peer0-org1.yaml
kubectl apply -f peer1-org1.yaml
kubectl apply -f peer0-org2.yaml
kubectl apply -f peer1-org2.yaml
#kubectl apply -f cli.yaml
