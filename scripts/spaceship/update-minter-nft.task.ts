import "../../env-config";
import { ethers } from "hardhat";
import configArgs from "./config-args";
import { writeFileSync } from "fs";
import { join } from "path";
import { delayTime } from "../@helpers/block-chain.helper";
import { Contract } from "ethers";
import { Spaceship, Spaceship__factory } from "../../typechain";

const { utils, getSigners, provider } = ethers;
const { formatEther } = utils;

const { NODE_ENV, NETWORK_PROVIDER } = configArgs;

const { NFT_ADDRESS } = require(`./outputs/${NODE_ENV}/nft.deploy.json`);
const { BOX_ADDRESS } = require(`./outputs/${NODE_ENV}/box.deploy.json`);

async function main() {
    const output = {};
    const [deployer] = await getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", formatEther(balance));
    Object.assign(output, {
        DEPLOYER_ADDRESS: deployer.address,
    })

    const nftCt = new Contract(
        NFT_ADDRESS,
        Spaceship__factory.abi,
        provider
    ) as Spaceship;


    console.log(`===== updateMinters =====`);
    const { transactionHash } = await (await nftCt.connect(deployer).updateMinters([BOX_ADDRESS], true)).wait();
    const txHash = `${NETWORK_PROVIDER.URL_SCAN}/tx/${transactionHash}`;

    console.log('----------txHash---------');
    console.log(txHash);
    console.log('-------------------');

    Object.assign(output, {
        txHash
    });

    await delayTime();
    try {
        const fileName = join(__dirname, `./outputs/${NODE_ENV}/update-minter-nft.task.json`)
        writeFileSync(fileName, JSON.stringify(output));
    } catch (error) {

    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});