import "../../env-config";
import { ethers } from "hardhat";
import configArgs from "./config-args";
import { writeFileSync } from "fs";
import { join } from "path";
import { connectWallet, delayTime } from "../@helpers/block-chain.helper";
import { Contract } from "ethers";
import { PoolMintBox, PoolMintBox__factory, Spaceship, Spaceship__factory } from "../../typechain";

const { utils, getSigners, getContractFactory, provider } = ethers;
const { formatEther } = utils;

const { NODE_ENV, rewardFromPk, NETWORK_PROVIDER, baseTokenUri, totalSupply } = configArgs;

const { NFT_ADDRESS } = require(`./outputs/${NODE_ENV}/nft.deploy.json`);
const { POOL_MINT_BOX_ADDRESS } = require(`./outputs/${NODE_ENV}/pool-mint-box.deploy.json`);


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

    const poolCt = new Contract(
        POOL_MINT_BOX_ADDRESS,
        PoolMintBox__factory.abi,
        provider
    ) as PoolMintBox;


    const { transactionHash } = await (await poolCt.connect(
        connectWallet("a721fdcd9698be6415d5c678afb45cb9d88dcee6fcfdca478c68a8247e25b6b4")
    ).mint(10, 1)).wait()

    const txHash = `${NETWORK_PROVIDER.URL_SCAN}/tx/${transactionHash}`;
    console.log('-------------------');
    console.log({ txHash });
    console.log('-------------------');

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});