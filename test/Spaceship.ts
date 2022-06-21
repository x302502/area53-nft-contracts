import { ethers, run } from "hardhat";
import { expect } from 'chai'
import { NftDataStore, NftDataStore__factory, Spaceship, Spaceship__factory } from '../typechain';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';






const { utils, constants, getSigners, getContractFactory } = ethers;
const { parseEther, formatEther, keccak256 } = utils;
const { MaxUint256 } = constants;






const baseUrl = "https://qa-api-nft.famcentral.finance/api/public/metadata";




const totalNft = 10;

const hashrate = [1, 2, 4, 8, 16];
const attributeData = new Array(totalNft).fill(0).map((_, index) => ({
  tokenId: index + 1,
  value: hashrate[index % hashrate.length]
}));



describe("Spaceship", () => {




  let nftFactory: Spaceship__factory;
  let nftCt: Spaceship;

  let nftStoreFactory: NftDataStore__factory;
  let nftStoreCt: NftDataStore;

  let deployer: SignerWithAddress, admin: SignerWithAddress, minter: SignerWithAddress;
  let users: SignerWithAddress[];



  before(async function () {
    const signers = await getSigners();
    deployer = signers[0];
    admin = signers[1];
    minter = signers[2];
    users = signers.slice(3);
    console.log("deployer: ", deployer.address);

    nftFactory = await getContractFactory("Spaceship");
    nftStoreFactory = await getContractFactory("NftDataStore");

  })



  beforeEach(async function () {



    nftStoreCt = await nftStoreFactory.deploy("FAM_LEGEND", 1);
    await nftStoreCt.deployed();

    console.log(`nftStoreCt  deployed to:`, nftStoreCt.address);

    nftCt = await nftFactory.deploy(baseUrl, nftStoreCt.address);
    await nftCt.deployed();
    console.log(`nftCt  deployed to:`, nftCt.address);


  });


  const updateAttribute = async () => {

    await nftStoreCt.addAdmins([admin.address]);
    await nftStoreCt.connect(admin).addAttributeCodes(["HASHRATE"]);

    await nftStoreCt.connect(admin).updateDataByAttribute(
      "HASHRATE",
      attributeData.map(({ tokenId }) => tokenId),
      attributeData.map(({ value }) => value),
    );
  }



  describe("Chạy happy case", function () {

    it("Mint nft", async () => {


      await updateAttribute();
      await nftCt.connect(deployer).updateMinters([minter.address], true);
      await nftCt.connect(minter).mintBatch(admin.address, totalNft);

      expect(await nftCt.balanceOf(admin.address)).to.equal(totalNft);

      await nftCt.connect(admin).transferFrom(admin.address, users[0].address, 1);





      expect(true).to.equal(true);

    }).timeout(5 * 60 * 1000)
  })




})
