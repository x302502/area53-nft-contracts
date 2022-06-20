import { IEnvConfig } from '..';

const config: IEnvConfig = {

  TOKEN_ADDRESS: {
    BNB: "0x0dE8FCAE8421fc79B29adE9ffF97854a424Cad09".trim(),
    BUSD: "0xe0dfffc2e01a7f051069649ad4eb3f518430b6a4".trim(),
    USDT: "0x55d398326f99059ff775485246999027b3197955".trim(),
    FAM: "0x302e8CD8bb32628364F918a3775F0E599BA5770C".trim(),
    NFT_FAMLEGEND: "0x5fD95ae46C67668807d42DEa0fe70503894D23c2".trim(),
  },
  DEX_CONTRACT: {
    PANCAKESWAP_FACTORY: "0x5Fe5cC0122403f06abE2A75DBba1860Edb762985".trim(),
    PANCAKESWAP_ROUTER: "0xCc7aDc94F3D80127849D2b41b6439b7CF1eB4Ae0".trim(),
  },
  NETWORK_PROVIDER: {
    URL_RPC: "https://testnet.aurora.dev",
    URL_WS: "",
    URL_SCAN: "https://testnet.aurorascan.dev"
  },
  API_BASE_URL: ""

}




export default config;
