
import "./env-config";
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-gas-reporter";
import "solidity-coverage";
const { WALLET_DEPLOYER_PRIVATEKEY, SCAN_APIKEY } = process.env;
const hexWalletDeployerPrivateKey = `0x${WALLET_DEPLOYER_PRIVATEKEY}`.trim();

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const config: HardhatUserConfig = {
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545",
    },
    hardhat: {
    },
    bscTestnet: {
      url: "https://data-seed-prebsc-2-s1.binance.org:8545/",
      chainId: 97,
      gasPrice: 20000000000,
      accounts: [hexWalletDeployerPrivateKey]
    },
    basTestnet: {
      url: "https://bas-aries-public.nodereal.io/",
      chainId: 117,
      gasPrice: 20000000000,
      accounts: [hexWalletDeployerPrivateKey]
    },
    bscMainnet: {
      url: "https://bsc-dataseed.binance.org/",
      chainId: 56,
      gasPrice: 20000000000,
      accounts: [hexWalletDeployerPrivateKey]
    },
    auroraTestnet: {
      url: "https://testnet.aurora.dev/",
      chainId: 1313161555,
      // gasPrice: 20000000000,
      accounts: [hexWalletDeployerPrivateKey]
    },
    auroraMainnet: {
      url: "https://mainnet.aurora.dev/",
      chainId: 1313161554,
      // gasPrice: 20000000000,
      accounts: [hexWalletDeployerPrivateKey]
    }
  },
  solidity: {
    compilers: [

      {
        version: '0.8.0',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          metadata: {
            bytecodeHash: 'none',
          },
        },
      },
      {
        version: '0.8.3',
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
          metadata: {
            bytecodeHash: 'none',
          },
        },
      },
    ],
  },

  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  },

  gasReporter: {
    enabled: true,
    currency: "USD",
  },
  etherscan: {
    apiKey: SCAN_APIKEY,
  },
};

export default config;
