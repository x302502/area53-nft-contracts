import { ethers } from "hardhat";
import { expect } from 'chai'
import { TokenERC1155, TokenERC1155__factory } from '../typechain';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';






const { utils, constants, getSigners, getContractFactory } = ethers;
const { parseEther, formatEther, keccak256 } = utils;
const { MaxUint256 } = constants;






const baseUrl = "https://qa-api-nft.famcentral.finance/api/public/metadata";

const ctName = "TokenERC1155";

describe(ctName, () => {


  let nftFactory: TokenERC1155__factory;
  let nftCt: TokenERC1155;

  let deployer: SignerWithAddress, admin: SignerWithAddress, rewardFrom: SignerWithAddress;
  let users: SignerWithAddress[];



  before(async function () {
    const signers = await getSigners();
    deployer = signers[0];
    admin = signers[1];
    rewardFrom = signers[2];
    users = signers.slice(3, 5);
    console.log("deployer: ", deployer.address);

    nftFactory = await getContractFactory(ctName);


  })



  beforeEach(async function () {
    nftCt = await nftFactory.deploy(baseUrl);
    await nftCt.deployed();
    console.log(`nftCt  deployed to:`, nftCt.address);


  });



  describe("Chạy happy case", function () {

    it("Mint nft", async () => {

      const userAddress = users[0].address;


      {
        const tokenId = 1;
        await nftCt.mint(userAddress, tokenId, 250);
        const tokenUri = await nftCt.uri(tokenId);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
      }

      {
        const tokenId = 2;
        await nftCt.mint(userAddress, tokenId, 250);
        const tokenUri = await nftCt.uri(tokenId);
        console.log('-------------------');
        console.log({ tokenUri });
        console.log('-------------------');
      }
      expect(true).to.equal(true);

    }).timeout(5 * 60 * 1000)
  })




})
