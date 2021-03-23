#!/bin/sh

#export env
#export PATH=/home/www/go/src/github.com/hyperledger/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=/home/www/go/src/github.com/hyperledger/fabric-samples/config/

export CORE_PEER_TLS_ENABLED=true

# export peer0.org2 env
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:30011


#create channel

#peer0.org1 join channel
peer channel join -b mychannel.block

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:30031

#peer0.org2 join channel
peer channel join -b mychannel.block

#export peer0.org1 env
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:30011

#install chaincode on peer0.org1
peer chaincode install -n sacc -v 1.0 -p chaincode/sacc

# export peer0.org2 env
export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:30031


#install chaincode on peer0.org2
peer chaincode install -n sacc -v 1.0 -p chaincode/sacc

#export peer0.org1 env
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:30011

#instantiate chaincode on peer0.org1
peer chaincode instantiate -o orderer.example.com:30050 --tls --cafile /home/www/byfn-on-k8s/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n sacc -v 1.0 -c '{"Args":["a", "100"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"

sleep 2m
peer chaincode query -C mychannel -n sacc -c '{"Args":["get","a"]}'

peer chaincode invoke -o orderer.example.com:30050 --tls true --cafile /home/www/byfn-on-k8s/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n sacc --peerAddresses peer0.org1.example.com:30011 --tlsRootCertFiles /home/www/byfn-on-k8s/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt --peerAddresses peer0.org2.example.com:30031 --tlsRootCertFiles /home/www/byfn-on-k8s/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt -c '{"Args":["set","a","20"]}'

sleep 1m

peer chaincode query -C mychannel -n sacc -c '{"Args":["get","a"]}'

