#! /bin/bash

clear
TIMESTAMP=$(date)

if [ "$1" == "Stop-Local-Blockchain-Nodes-Clean-Environment" ]; then
  echo
  echo "------------------------------------[[[[ Stop-Local-Blockchain-Nodes-Clean-Environment ]]]]------------------------------------"
  echo
  echo "This command will stop any locally running network nodes and clean up any logs leftover from old runs. Feel free to run this command multiple times to clean up files listed below. This run started on $TIMESTAMP."
  echo
  killall yarn > /dev/null 2>&1
  killall npm > /dev/null 2>&1
  killall node > /dev/null 2>&1
  pkill yarnn > /dev/null 2>&1
  pkill npm > /dev/null 2>&1
  pkill node > /dev/null 2>&1
  ps aux | grep node
  rm -rf ./logs/*.log
  npx hardhat clean
  echo
  echo
  TIMESTAMP2=$(date)
  echo "This run ended on $TIMESTAMP2."
fi

if [ "$1" == "Install-Tools-On-MacOS-Or-Linux" ]; then
  echo
  echo "------------------------------------[[[[ Install-Tools-On-MacOS-Or-Linux ]]]]------------------------------------"
  echo
  echo "This command will install all of the required Node.js packages. This script was created on MacOS, but can be used in any Linux Distro that has curl installed. This run started on $TIMESTAMP."
  echo
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash &&
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm install 18
  nvm use 18
  nvm alias default 18
  node --version
  rm -rf ./node_modules
  npm install npm --global --silent
  npm update --silent
  npm install 2> >(grep -v warning 1>&2)
  npx hardhat 2> >(grep -v warning 1>&2)
  ## If there are no serious issues with your local install, do not un-comment the following line.
  #npm audit fix --force
  echo
  echo
  TIMESTAMP2=$(date)
  echo "This run ended on $TIMESTAMP2."
fi

if [ "$1" == "Start-Deployment-On-Local-Default-Hardhat-Node" ]; then
  echo
  echo "------------------------------------[[[[ Start-Deployment-On-Local-Default-Hardhat-Node ]]]]------------------------------------"
  echo
  echo "This command will run the Start-Deployment-On-Local-Default-Hardhat-Node script. This run started on $TIMESTAMP."
  echo
  killall yarn > /dev/null 2>&1
  killall npm > /dev/null 2>&1
  killall node > /dev/null 2>&1
  pkill yarnn > /dev/null 2>&1
  pkill npm > /dev/null 2>&1
  pkill node > /dev/null 2>&1
  sleep 4
  source ./.env
  npx hardhat node > ./logs/hardhat-default-network-node-standalone-mode.log &
  sleep 10
  echo
  echo
  echo "-------->>>> Deployment Results Log :: $1 :: $2 <<<<--------" > ./logs/hardhat-contract-ethereum-testnet-deployment.log
  npm run deploy --network $2 >> ./logs/hardhat-contract-ethereum-testnet-deployment.log &&
  cat ./logs/hardhat-contract-ethereum-testnet-deployment.log
  echo
  echo
  TIMESTAMP2=$(date)
  echo "This run ended on $TIMESTAMP2."
fi

if [ "$1" == "Start-Deployment-On-Real-Ethereum-Testnet" ]; then
  echo
  echo "------------------------------------[[[[ Start-Deployment-On-Real-Ethereum-Testnet ]]]]------------------------------------"
  echo
  echo "This command will run the Start-Deployment-On-Real-Ethereum-Testnet script. This run started on $TIMESTAMP."
  echo
  killall yarn > /dev/null 2>&1
  killall npm > /dev/null 2>&1
  killall node > /dev/null 2>&1
  pkill yarnn > /dev/null 2>&1
  pkill npm > /dev/null 2>&1
  pkill node > /dev/null 2>&1
  sleep 4
  source ./.env
  echo
  echo
  echo "-------->>>> Deployment Results Log :: $1 :: Sepolia <<<<--------" > ./logs/hardhat-contract-ethereum-testnet-deployment.log
  npm run deploy --network sepolia >> ./logs/hardhat-contract-ethereum-testnet-deployment.log &&
  cat ./logs/hardhat-contract-ethereum-testnet-deployment.log
  echo
  echo
  TIMESTAMP2=$(date)
  echo "This run ended on $TIMESTAMP2."
fi

if [ "$1" == "Start-Hardhat-Test" ]; then
  echo
  echo "------------------------------------[[[[ Start-Hardhat-Test ]]]]------------------------------------"
  echo
  echo "This command will run the Start-Hardhat-Test script. This run started on $TIMESTAMP."
  echo
  source ./.env
  npx hardhat node > ./logs/hardhat-default-network-node-standalone-mode.log &
  sleep 10
  npx hardhat test > ./logs/hardhat-test-report.log
  sleep 2
  cat ./gas-report.txt >> ./logs/hardhat-test-report.log
  cat ./logs/hardhat-test-report.log
  echo
  echo
  TIMESTAMP2=$(date)
  echo "This run ended on $TIMESTAMP2."
fi

usage_explanation() {
  echo
  echo
  echo "------------------------------------[[[[ Tool Runner Script ]]]]------------------------------------"
  echo
  echo
  echo "This tool runner script can be used to run the following commands to deploy the Solidity examples from the Patrick Collins FCC Solidity YouTube course."
  echo
  echo "You can view just this help menu again (without triggering any automation) by running 'bash ./Lesson11CodeSessions_start-deployment-scripts.sh -h' or 'bash ./Lesson11CodeSessions_start-deployment-scripts.sh -h --help'."
  echo
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Stop-Local-Blockchain-Nodes-Clean-Environment"
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Install-Tools-On-MacOS-Or-Linux"
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Start-Deployment-On-Local-Default-Hardhat-Node"
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Start-Deployment-On-Real-Ethereum-Testnet"
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Start-Hardhat-Test"
  echo
  echo "If you're running this for the first time run the following before running any of these scripts."
  echo
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Install-Tools-On-MacOS-Or-Linux"
  echo
  echo "Then you can run the following combined commands in your terminal to deploy the contract to the Hardhat local blockchain node."
  echo
  echo "bash ./Lesson11CodeSessions_start-deployment-scripts.sh Stop-Local-Blockchain-Nodes && bash ./Lesson11CodeSessions_start-deployment-scripts.sh Start-Deployment-On-Local-Default-Hardhat-Node hardhat"
  echo
  echo "You can also use the provided Lesson11CodeSessions_start-automation-build-pipeline.sh to run all the above commands in a sequence similar to a build pipeline."
  echo
  echo "bash ./Lesson11CodeSessions_start-automation-build-pipeline.sh"
  echo
  echo
}

error_handler() {
  local error_message="$@"
  echo "${error_message}" 1>&2;
}

argument="$1"
if [[ -z $argument ]] ; then
  usage_explanation
else
  case $argument in
    -h|--help)
      usage_explanation
      ;;
    *)
      usage_explanation
      ;;
  esac
fi
