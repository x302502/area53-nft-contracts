import "../env-config";
import { ethers } from "hardhat";
import { TokenERC1155 } from "../typechain";
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
    const tokenErc1155Factory = await getContractFactory("TokenERC1155");
    const tokenErc1155 = await tokenErc1155Factory.deploy(baseUrl) as TokenERC1155;
    await tokenErc1155.deployed();
    console.log(`TokenERC1155 deployed to:`, tokenErc1155.address);

    // const userAddress = "0xf582D3eFC232Ee422fE126cEA632D9FFb4CC8CC9";
    const userAddress = "0x2aD47080002f400A4c4682fb04007BE492Cc606a";
    {
        const tokenId = 1;
        const tx = await tokenErc1155.mint(userAddress, tokenId, 250);
        const receipt = await tx.wait();
        const txHash = `${URL_SCAN}/tx/${receipt.transactionHash}`.trim();
        console.log('-------------------');
        console.log(txHash);
        console.log('-------------------');
        const tokenUri = await tokenErc1155.uri(tokenId);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
    }
    {
        const tokenId = 2;
        const tx = await tokenErc1155.mint(userAddress, tokenId, 250);
        const receipt = await tx.wait();
        const txHash = `${URL_SCAN}/tx/${receipt.transactionHash}`.trim();
        console.log('-------------------');
        console.log(txHash);
        console.log('-------------------');
        const tokenUri = await tokenErc1155.uri(tokenId);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
    }
    {
        const tokenId = 3;
        const tx = await tokenErc1155.mint(userAddress, tokenId, 250);
        const receipt = await tx.wait();
        const txHash = `${URL_SCAN}/tx/${receipt.transactionHash}`.trim();
        console.log('-------------------');
        console.log(txHash);
        console.log('-------------------');
        const tokenUri = await tokenErc1155.uri(tokenId);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
    }

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});