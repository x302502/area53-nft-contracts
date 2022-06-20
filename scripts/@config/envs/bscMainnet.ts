import { IEnvConfig } from '..';

const config: IEnvConfig = {

  TOKEN_ADDRESS: {
    BNB: "0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c".trim(),
    BUSD: "0xe9e7cea3dedca5984780bafc599bd69add087d56".trim(),
    USDT: "0x55d398326f99059ff775485246999027b3197955".trim(),
    FAM: "0x4556a6f454f15c4cd57167a62bda65a6be325d1f".trim(),
    NFT_FAMLEGEND: "0x92D41Ea85fe9c16E4483fDad0a471B861aF14280".trim(),
  },
  DEX_CONTRACT: {
    PANCAKESWAP_FACTORY: "0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73".trim(), //pancakeswap
    PANCAKESWAP_ROUTER: "0x10ED43C718714eb63d5aA57B78B54704E256024E".trim(), // pancakeswap
    // APESWAP_FACTORY: "0x0841BD0B734E4F5853f0dD8d7Ea041c241fb0Da6".trim(), //apeswap
    // APESWAP_ROUTER: "0xcF0feBd3f17CEf5b47b0cD257aCf6025c5BFf3b7".trim(), // apeswap
  },
  NETWORK_PROVIDER: {

    //URL_RPC: "https://binance.ankr.com",
    //  URL_RPC: "https://bsc-dataseed1.defibit.io",
    // URL_RPC: "https://bsc-dataseed2.defibit.io",
    // URL_RPC: "https://bsc-dataseed3.defibit.io",
    // URL_RPC: "https://bsc-dataseed4.defibit.io",
    URL_RPC: "https://bsc-dataseed.binance.org",
    // URL_RPC: "https://dataseed4.binance.org",
    //  URL_RPC: "https://speedy-nodes-nyc.moralis.io/2960ee097d3b6231845dae26/bsc/mainnet",
    // URL_RPC: "https://speedy-nodes-nyc.moralis.io/2960ee097d3b6231845dae26/bsc/mainnet/archive",


    URL_WS: "wss://bsc-ws-node.nariox.org:443",
    //URL_WS: "wss://apis.ankr.com/wss/acc56efc5b274cb188954964c51e78ba/7198a65ef7f70df9f41d9dc1e6747976/binance/full/main",
    // URL_WS: "wss://speedy-nodes-nyc.moralis.io/2960ee097d3b6231845dae26/bsc/mainnet/ws",
    // URL_WS: "wss://speedy-nodes-nyc.moralis.io/2960ee097d3b6231845dae26/bsc/mainnet/archive/ws",
    URL_SCAN: "https://bscscan.com"
  },
  API_BASE_URL: "https://api-nft.famcentral.finance"
}

export default config;
