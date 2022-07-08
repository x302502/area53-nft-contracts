import "../../env-config";
import { ethers, run } from "hardhat";
import configArgs from "./config-args";
import { writeFileSync } from "fs";
import { join } from "path";
import { delayTime } from "../@helpers/block-chain.helper";

const { utils, getSigners, getContractFactory } = ethers;
const { formatEther } = utils;


const { NODE_ENV, baseTokenUri, NETWORK_PROVIDER } = configArgs;

async function main() {
    const output = {};
    const [deployer] = await getSigners();
    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", formatEther(balance));
    Object.assign(output, {
        DEPLOYER_ADDRESS: deployer.address,
    })

    const nftFactory = await getContractFactory("Spaceship");
    const nftCt = await nftFactory.deploy(baseTokenUri)
    await nftCt.deployed();

    const linkDeploy = `${NETWORK_PROVIDER.URL_SCAN}/address/${nftCt.address}`.trim();
    console.log('--------linkDeploy-----------');
    console.log(linkDeploy);
    console.log('-------------------');
    Object.assign(output, {
        NFT_ADDRESS: nftCt.address,
    });


    try {
        if (NODE_ENV.includes("Mainnet")) {
            console.log('--------verify-----------');
            await run("verify:verify", {
                address: nftCt.address,
                constructorArguments: [baseTokenUri],
            });
        }
    } catch (error) {
        console.log('---------Verify error----------');
        console.log(error);
        console.log('-------------------');
    }



    await delayTime();
    try {
        const fileName = join(__dirname, `./outputs/${NODE_ENV}/nft.deploy.json`)
        writeFileSync(fileName, JSON.stringify(output));
    } catch (error) {

    }
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});