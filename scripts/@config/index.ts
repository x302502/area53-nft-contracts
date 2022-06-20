import * as envs from './envs';

export interface IEnvConfig {
  NAME?: string,
  TOKEN_ADDRESS: {
    BNB: string;
    BUSD: string;
    USDT: string;
    FAM: string;
    NFT_FAMLEGEND: string;
  },
  DEX_CONTRACT: {
    PANCAKESWAP_FACTORY: string;
    PANCAKESWAP_ROUTER: string;
  },
  NETWORK_PROVIDER: {
    URL_RPC: string;
    URL_WS: string;
    URL_SCAN: string;
  },
  API_BASE_URL: string;
}

let envConfig: IEnvConfig = undefined;
export function configEnv(): IEnvConfig {
  if (envConfig) {
    return envConfig;
  }
  const envName = process.env.NODE_ENV || 'bscTestnet';
  const currentConfig = (envs)[envName];
  return {
    ...currentConfig,
    NAME: envName
  }
};

