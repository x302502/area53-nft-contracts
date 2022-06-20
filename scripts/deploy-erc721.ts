import "../env-config";
import { ethers } from "hardhat";
import { TokenERC1155, TokenERC721 } from "../typechain";
import { configEnv } from "./@config";

const { utils, constants, getSigners, getContractFactory } = ethers;
const { formatEther } = utils;
const { MaxUint256, Zero, AddressZero, HashZero } = constants;
const {
    NODE_ENV = "bscTestnet",
} = process.env;


const { TOKEN_ADDRESS, NETWORK_PROVIDER } = configEnv();
const { URL_SCAN } = NETWORK_PROVIDER;

const baseUrl = "https://qa-api-nft.famcentral.finance/api/public/metadata";

async function main() {

    const [deployer] = await getSigners();

    console.log("Deploying contracts with the account:", deployer.address);
    const balance = await deployer.getBalance();
    console.log("Account balance:", formatEther(balance));
    const tokenFactory = await getContractFactory("TokenERC721");
    const tokenCt = await tokenFactory.deploy("FAM DAO TEST", "FDAO", baseUrl) as TokenERC721;
    await tokenCt.deployed();
    console.log(`TokenERC721 deployed to:`, tokenCt.address);

    // const userAddress = "0xf582D3eFC232Ee422fE126cEA632D9FFb4CC8CC9";
    const userAddress = "0xf582D3eFC232Ee422fE126cEA632D9FFb4CC8CC9";
    {
        const qty = 5;
        const tx = await tokenCt.mintBatch(userAddress, qty);
        const receipt = await tx.wait();
        const txHash = `${URL_SCAN}/tx/${receipt.transactionHash}`.trim();
        console.log('-------------------');
        console.log(txHash);
        console.log('-------------------');
        const tokenUri = await tokenCt.tokenURI(1);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
    }


}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});