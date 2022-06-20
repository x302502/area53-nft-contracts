import { BigNumber } from "ethers";


export interface IRawParamInoPoolSwap {
    startTime: string;
    endTime: string;
    storeInfos: {
        collection: string;
        price: number;
        tokenIds: number[];
    }[]
}

export interface IParamInoPoolSwap {
    startTime: number;
    endTime: number;
    storeInfos: {
        collection: string;
        price: BigNumber;
        tokenIds: number[];
    }[]
}