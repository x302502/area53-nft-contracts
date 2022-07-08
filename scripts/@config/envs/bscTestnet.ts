import { IEnvConfig } from '..';

const config: IEnvConfig = {

  TOKEN_ADDRESS: {
    BNB: "0x0dE8FCAE8421fc79B29adE9ffF97854a424Cad09".trim(),
    BUSD: "0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7".trim(),
    USDT: "0x7ef95a0FEE0Dd31b22626fA2e10Ee6A223F8a684".trim(),
    FAM: "0x302e8CD8bb32628364F918a3775F0E599BA5770C".trim(),
    NFT_FAMLEGEND: "0xD0b29a997aa6860381181560500457814E5798cd".trim(),
  },
  DEX_CONTRACT: {
    PANCAKESWAP_FACTORY: "0x5Fe5cC0122403f06abE2A75DBba1860Edb762985".trim(),
    PANCAKESWAP_ROUTER: "0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0".trim(),
  },
  NETWORK_PROVIDER: {
    URL_RPC: "https://data-seed-prebsc-1-s2.binance.org:8545",
    URL_WS: "wss://data-seed-prebsc-2-s2.binance.org:8545",
    URL_SCAN: "https://testnet.bscscan.com"
  },
  API_BASE_URL: "https://api.area53.asia".trim()
}

export default config;
