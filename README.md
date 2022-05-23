# DailyWageInCrypto
A smart contract for employers to easily pay salaries to employees in crypto.
# Project description
The point of this project is to help both the employer and their employees
The employee might want a secure trustless way of receiving daily payments for his or her work, ensuring their time and effort is rewarded
Employees might also want to receive their pay on a daily basis out of convenience or neccessity.
The employer might want to setup a good smart contract for his/her employees because it could boost their productivity and save the employer some money because employees who opt to receive their money trough cryptocurrency on a daily basis will pay for the gas fees (this smart contract is ideally used on a network that has standard transaction fees below 1$)
That means that if a monthly wage of 1000$ is agreed upon, the owner will just put 1000$ into the smart contract in the native currency of the used blockchain network and roughly 33$ will be sent out of the contract, with the employee receiving more than 32.9$ on low transaction fee networks.
Deploying the contract should also cost below 1$ as it is well optimized and small in size.

1. Smart contract attaches to the employer (owner) address on one end and employees addresses on the other
2. The employer has complete control of the smart contract and all funds in this contract that haven't yet been paid
3. The smart contract automatically sends the predetermined amount in predetermined time intervals to all employee addresses
4. The employer can at any moment stop paying his employee
# How to use
1. Initialize a hardhat project in an empty folder with npx hardhat and install all the hardhat plugins/dependencies
2. Replace the greeter.sol contract in the contracts folder with WageContract.sol and replace the deploy.js with the one provided in the repo or write it yourself
3. Setup your .env file and hardhat.config 
4. npx hardhat compile 
5. npx hardhat run scripts/deploy.js --network "network"
6. npx hardhat verify "contract address" --network "network"
7. Done
