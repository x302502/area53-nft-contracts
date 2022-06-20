


import "../env-config";
import { ethers, network } from "hardhat";
import { writeFileSync } from "fs";
const { utils, constants, } = ethers;
const { parseEther, formatEther } = utils;
const { MaxUint256, Zero, AddressZero, HashZero } = constants;
const {
    NODE_ENV = "bscTestnet",
    HARDHAT_NETWORK,
    BSC_SCAN_URL,
    WALLET_DEPLOYER_PRIVATEKEY,
    WALLET_REWARD_PRIVATEKEY,
    WALLET_ADMIN_ADDRESS,
    WALLET_REWARD_ADDRESS,
    FAM_TOKEN_ADDRESS,
    NFT_FAMLEGEND_ADDRESS
} = process.env;

const wallets = [];
async function main() {
    for (let i = 0; i < 50; i++) {
        const wallet = ethers.Wallet.createRandom();
        const address = wallet.address;
        const phrase = wallet.mnemonic.phrase;
        const privateKey = wallet.privateKey;
        wallets.push({
            address,
            phrase,
            privateKey
        });
    }
    try {
        const fileName = `./outputs/50vi-stman-2503.json`;
        writeFileSync(fileName, JSON.stringify(wallets));
        const fileNameAddress = `./outputs/50vi-stman-2503-address-${new Date().getTime()}.json`;
        writeFileSync(fileNameAddress, JSON.stringify(wallets.map(v => {
            return {
                address: v.address
            }
        })));
    } catch (error) {

    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});



// FLUX 70 1.11
// IMX 136 1.243
// DYDX 46 2.91
// GRT 550 0.229
// ARPA 3150 0.038
// SRM 83  1.39