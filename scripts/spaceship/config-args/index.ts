import { configEnv } from "../../@config";

const {
    NODE_ENV = "bscTestnet",
    NFTV2_WALLET_REWARD_PRIVATEKEY,
} = process.env;

const { TOKEN_ADDRESS, NETWORK_PROVIDER, API_BASE_URL } = configEnv();

const rewardFromPk = NFTV2_WALLET_REWARD_PRIVATEKEY;
const baseTokenUri = `${API_BASE_URL}/api/public/metadata`;
const totalSupply = NODE_ENV.includes("Testnet") ? 10 : 10;

export default {
    baseTokenUri,
    NODE_ENV,
    NETWORK_PROVIDER,
    TOKEN_ADDRESS,
    rewardFromPk,
    totalSupply
}