import { BigNumber } from "ethers";



export enum EDepositRoundType {
    WhiteList,
    PublicSale
}

export interface IRawWhiteList {
    walletAddress: string, allocation: string | number
}

export interface IRawUserDeposit {
    walletAddress: string, amountDeposit: string | number
}

export interface IRawParamIdoPoolNonClaim {
    totalAllocation: number;
    guarantee: {
        roundIndex: number;
        startBlock: string;
        endBlock: string;
        allocationPublicSale: number;
        roundType: 0 | 1;
    },
    fcfs: {
        roundIndex: number;
        startBlock: string;
        endBlock: string;
        allocationPublicSale: number;
        roundType: 0 | 1;
    }

}



export interface IParamIdoPoolNonClaim {
    totalAllocation: BigNumber;
    guarantee: {
        roundIndex: number;
        startBlock: number;
        endBlock: number;
        allocationPublicSale: BigNumber;
        roundType: EDepositRoundType;
    },
    fcfs: {
        roundIndex: number;
        startBlock: number;
        endBlock: number;
        allocationPublicSale: BigNumber;
        roundType: EDepositRoundType;
    }

}

export interface IRawParamIdoPoolClaim {
    rateDeposit: number;
    rateClaim: number;
    vestingSchedules: {
        startTime: string;
        percent: number;
    }[]
}



export interface IParamIdoPoolClaim {
    rateDeposit: number;
    rateClaim: number;
    vestingSchedules: {
        startTime: number;
        percent: number;
    }[]
}



export interface IRawParamIdoPoolDepositWhiteList {
    totalAllocation: number;
    startTime: string;
    endTime: string;
}

export interface IParamIdoPoolDepositWhiteList {
    totalAllocation: BigNumber;
    startTime: number;
    endTime: number;
}


export interface IRawParamIdoPoolDepositPublic {
    totalAllocation: number;
    allocation: number;
    startTime: string;
    endTime: string;
}

export interface IParamIdoPoolDepositPublic {
    totalAllocation: BigNumber;
    allocation: BigNumber;
    startTime: number;
    endTime: number;
}