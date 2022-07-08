import "../../env-config";
import { ethers } from "hardhat";
import configArgs from "./config-args";
import { writeFileSync } from "fs";
import { join } from "path";
import { delayTime } from "../@helpers/block-chain.helper";
import { Contract } from "ethers";
import { SpaceshipBox, SpaceshipBox__factory } from "../../typechain";

const { utils, getSigners, getContractFactory, provider } = ethers;
const { formatEther } = utils;

const { NODE_ENV, rewardFromPk, NETWORK_PROVIDER, baseTokenUri, totalSupply } = configArgs;

const { BOX_ADDRESS } = require(`./outputs/${NODE_ENV}/box.deploy.json`);


const level = 1;

async function main() {
    const output = {};
    const [deployer] = await getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", formatEther(balance));
    Object.assign(output, {
        DEPLOYER_ADDRESS: deployer.address,
    })

    const rewardFrom = (new ethers.Wallet(`0x${rewardFromPk}`)).connect(provider);

    console.log('---------rewardFrom----------');
    console.log(rewardFrom.address);
    console.log('-------------------');

    Object.assign(output, {
        rewardFrom: rewardFrom.address,
    })

    const boxCt = new Contract(
        BOX_ADDRESS,
        SpaceshipBox__factory.abi,
        provider
    ) as SpaceshipBox;


    console.log(`===== mintBatch =====`);
    const step = 20;
    const txs = [];
    for (let i = 0; i < totalSupply; i += step) {
        const size = i + step > totalSupply ? totalSupply - i : step;
        const { transactionHash } = await (await boxCt.connect(deployer).mintBatch(rewardFrom.address, size, level)).wait();
        const txHash = `${NETWORK_PROVIDER.URL_SCAN}/tx/${transactionHash}`;

        console.log('=====STEP=====', `: ${i}`);
        console.log('----------txHash---------');
        console.log(txHash);
        console.log('-------------------');

        txs.push(txHash);
    }
    Object.assign(output, {
        txs
    });

    await delayTime();
    try {
        const fileName = join(__dirname, `./outputs/${NODE_ENV}/mint-box.task.json`)
        writeFileSync(fileName, JSON.stringify(output));
    } catch (error) {

    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});