#!/bin/sh

#source /etc/profile
export PATH=/home/www/go/src/github.com/hyperledger/fabric-samples/bin:$PATH
export FABRIC_CFG_PATH=/home/www/go/src/github.com/hyperledger/fabric-samples/config/
export CORE_PEER_TLS_ENABLED=true

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:30011

#create channel
peer channel create -o orderer.example.com:30050 -c mychannel -f channel-artifacts/channel.tx --tls --cafile /home/www/baas-template/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem

peer channel join -b mychannel.block

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/baas-template/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/baas-template/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:30031

peer channel join -b mychannel.block

export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
export CORE_PEER_ADDRESS=peer0.org1.example.com:30011

peer chaincode install -n mycc -v 1.0 -p github.com/example_cc

export CORE_PEER_LOCALMSPID="Org2MSP"
export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/baas-template/crypto-config/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt
export CORE_PEER_MSPCONFIGPATH=/home/www/baas-template/crypto-config/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp
export CORE_PEER_ADDRESS=peer0.org2.example.com:30031

peer chaincode install -n mycc -v 1.0 -p github.com/example_cc

#export CORE_PEER_LOCALMSPID="Org1MSP"
#export CORE_PEER_TLS_ROOTCERT_FILE=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
#export CORE_PEER_MSPCONFIGPATH=/home/www/baas-template/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp
#export CORE_PEER_ADDRESS=peer0.org1.example.com:30011

#peer chaincode instantiate -o orderer.example.com:30050 --tls --cafile /home/www/baas-template/crypto-config/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem -C mychannel -n mycc -v 1.0 -c '{"Args":["a", "100"]}' -P "AND ('Org1MSP.peer','Org2MSP.peer')"



