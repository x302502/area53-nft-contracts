import "../../env-config";
import { ethers, run } from "hardhat";
import configArgs from "./config-args";
import { writeFileSync } from "fs";
import { join } from "path";
import { delayTime, parseAmountToken } from "../@helpers/block-chain.helper";

const { utils, getSigners, getContractFactory } = ethers;
const { formatEther } = utils;


const { NODE_ENV, NETWORK_PROVIDER, TOKEN_ADDRESS } = configArgs;

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

    const poolFactory = await getContractFactory("PoolMintBox");
    const poolCt = await poolFactory.deploy(
        BOX_ADDRESS, TOKEN_ADDRESS.BUSD,
        [parseAmountToken(1), parseAmountToken(2), parseAmountToken(3)], 100
    );
    await poolCt.deployed();

    const linkDeploy = `${NETWORK_PROVIDER.URL_SCAN}/address/${poolCt.address}`.trim();
    console.log('--------linkDeploy-----------');
    console.log(linkDeploy);
    console.log('-------------------');
    Object.assign(output, {
        POOL_MINT_BOX_ADDRESS: poolCt.address,
    });





    try {
        if (NODE_ENV.includes("Mainnet")) {
            console.log('--------verify-----------');
            await run("verify:verify", {
                address: poolCt.address,
                constructorArguments: [
                    BOX_ADDRESS, TOKEN_ADDRESS.BUSD,
                    [parseAmountToken(1), parseAmountToken(2), parseAmountToken(3)], 100
                ],
            });
        }
    } catch (error) {
        console.log('---------Verify error----------');
        console.log(error);
        console.log('-------------------');
    }



    await delayTime();
    try {
        const fileName = join(__dirname, `./outputs/${NODE_ENV}/pool-mint-box.deploy.json`)
        writeFileSync(fileName, JSON.stringify(output));
    } catch (error) {

    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});