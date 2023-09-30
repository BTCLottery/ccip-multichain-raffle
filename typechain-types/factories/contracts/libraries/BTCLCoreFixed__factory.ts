/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import { Signer, utils, Contract, ContractFactory, Overrides } from "ethers";
import type { Provider, TransactionRequest } from "@ethersproject/providers";
import type { PromiseOrValue } from "../../../common";
import type {
  BTCLCoreFixed,
  BTCLCoreFixedInterface,
} from "../../../contracts/libraries/BTCLCoreFixed";

const _abi = [
  {
    inputs: [],
    name: "INVALID_VRF_REQUEST",
    type: "error",
  },
  {
    inputs: [],
    name: "LOTTERY_PAUSED",
    type: "error",
  },
  {
    inputs: [],
    name: "PRIZE_ALREADY_CLAIMED",
    type: "error",
  },
  {
    inputs: [],
    name: "ROUND_NOT_FINISHED",
    type: "error",
  },
  {
    inputs: [],
    name: "TRANSFER_FAILED",
    type: "error",
  },
  {
    inputs: [],
    name: "UNAUTHORIZED_WINNER",
    type: "error",
  },
  {
    inputs: [],
    name: "UPKEEP_FAILED",
    type: "error",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "roundNr",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "totalTickets",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "totalPlayers",
        type: "uint256",
      },
    ],
    name: "LotteryClosed",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "roundNr",
        type: "uint256",
      },
    ],
    name: "LotteryOpened",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "roundNr",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "totalBets",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "totalTickets",
        type: "uint256",
      },
    ],
    name: "TicketsPurchased",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "uint256",
        name: "amountToken",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amountETH",
        type: "uint256",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "liquidity",
        type: "uint256",
      },
    ],
    name: "TokensLiquified",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "amount",
        type: "uint256[]",
      },
    ],
    name: "TreasuryClaimedMulti",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "amount",
        type: "uint256",
      },
    ],
    name: "TreasuryClaimedSingle",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256[]",
        name: "rounds",
        type: "uint256[]",
      },
    ],
    name: "WinnerClaimedPrizeMulti",
    type: "event",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "player",
        type: "address",
      },
      {
        indexed: false,
        internalType: "uint256",
        name: "rounds",
        type: "uint256",
      },
    ],
    name: "WinnerClaimedPrizeSingle",
    type: "event",
  },
  {
    inputs: [],
    name: "BITMASK_LAST_INDEX",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "BITMASK_PURCHASER",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "BITPOS_LAST_INDEX",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "totalWinners",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "totalAmount",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "decimals",
        type: "uint256",
      },
    ],
    name: "calculateRewards",
    outputs: [
      {
        internalType: "uint256[]",
        name: "rewards",
        type: "uint256[]",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "enum BTCLCoreFixed.Status",
        name: "status",
        type: "BTCLCoreFixed.Status",
      },
      {
        internalType: "uint256",
        name: "requestId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "totalBets",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "maxPlayers",
        type: "uint256",
      },
    ],
    name: "checkUpkeepVRF",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "pure",
    type: "function",
  },
] as const;

const _bytecode =
  "0x6115b861003a600b82828239805160001a60731461002d57634e487b7160e01b600052600060045260246000fd5b30600052607381538281f3fe730000000000000000000000000000000000000000301460806040526004361061007b5760003560e01c80636967609b1161005a5780636967609b146100f8578063745052c014610100578063d29c7cbe1461012057600080fd5b8062bc81641461008057806314d7847f146100ae57806356d5d004146100d5575b600080fd5b61009b73ffffffffffffffffffffffffffffffffffffffff81565b6040519081526020015b60405180910390f35b61009b7fffffffffffffffffffffffff000000000000000000000000000000000000000081565b6100e86100e3366004611252565b610142565b60405190151581526020016100a5565b61009b60a081565b61011361010e366004611291565b610186565b6040516100a591906112bd565b81801561012c57600080fd5b5061014061013b366004611301565b6111b3565b005b60008085600281111561015757610157611346565b148015610162575083155b801561016d57508183145b1561017a5750600161017e565b5060005b949350505050565b606060018410806101975750600a84115b156101b157506040805160008152602081019091526111ac565b8367ffffffffffffffff8111156101ca576101ca611375565b6040519080825280602002602001820160405280156101f3578160200160208202803683370190505b509050836001036102375761020982600a6114f5565b6102139084611501565b8160008151811061022657610226611518565b6020026020010181815250506111ac565b836002036102c657600a61024b83826114f5565b610256856006611501565b6102609190611501565b61026a9190611547565b8160008151811061027d5761027d611518565b6020908102919091010152600a61029483826114f5565b61029f856004611501565b6102a99190611501565b6102b39190611547565b8160018151811061022657610226611518565b836003036103a15760646102db83600a6114f5565b6102e685602d611501565b6102f09190611501565b6102fa9190611547565b8160008151811061030d5761030d611518565b6020908102919091010152606461032583600a6114f5565b610330856023611501565b61033a9190611501565b6103449190611547565b8160018151811061035757610357611518565b6020908102919091010152606461036f83600a6114f5565b61037a856014611501565b6103849190611501565b61038e9190611547565b8160028151811061022657610226611518565b836004036104c55760646103b683600a6114f5565b6103c185602d611501565b6103cb9190611501565b6103d59190611547565b816000815181106103e8576103e8611518565b6020908102919091010152600a6103ff83826114f5565b61040a856003611501565b6104149190611501565b61041e9190611547565b8160018151811061043157610431611518565b6020908102919091010152606461044983600a6114f5565b61045485600f611501565b61045e9190611501565b6104689190611547565b8160028151811061047b5761047b611518565b6020908102919091010152606461049383600a6114f5565b61049e85600a611501565b6104a89190611501565b6104b29190611547565b8160038151811061022657610226611518565b8360050361063357600a6104d983826114f5565b6104e4856005611501565b6104ee9190611501565b6104f89190611547565b8160008151811061050b5761050b611518565b6020908102919091010152606461052383600a6114f5565b61052e856015611501565b6105389190611501565b6105429190611547565b8160018151811061055557610555611518565b6020908102919091010152606461056d83600a6114f5565b61057885600c611501565b6105829190611501565b61058c9190611547565b8160028151811061059f5761059f611518565b602090810291909101015260646105b783600a6114f5565b6105c2856009611501565b6105cc9190611501565b6105d69190611547565b816003815181106105e9576105e9611518565b6020908102919091010152606461060183600a6114f5565b61060c856008611501565b6106169190611501565b6106209190611547565b8160048151811061022657610226611518565b836006036107e957600a61064783826114f5565b610652856005611501565b61065c9190611501565b6106669190611547565b8160008151811061067957610679611518565b6020908102919091010152600a61069083826114f5565b61069b856002611501565b6106a59190611501565b6106af9190611547565b816001815181106106c2576106c2611518565b6020908102919091010152600a6106d983826114f5565b6106e4856001611501565b6106ee9190611501565b6106f89190611547565b8160028151811061070b5761070b611518565b6020908102919091010152606461072383600a6114f5565b61072e856008611501565b6107389190611501565b6107429190611547565b8160038151811061075557610755611518565b6020908102919091010152606461076d83600a6114f5565b610778856007611501565b6107829190611501565b61078c9190611547565b8160048151811061079f5761079f611518565b602090810291909101015260646107b783600a6114f5565b6107c2856005611501565b6107cc9190611501565b6107d69190611547565b8160058151811061022657610226611518565b836007036109ea57600a6107fd83826114f5565b610808856005611501565b6108129190611501565b61081c9190611547565b8160008151811061082f5761082f611518565b6020908102919091010152600a61084683826114f5565b610851856002611501565b61085b9190611501565b6108659190611547565b8160018151811061087857610878611518565b6020908102919091010152606461089083600a6114f5565b61089b856008611501565b6108a59190611501565b6108af9190611547565b816002815181106108c2576108c2611518565b602090810291909101015260646108da83600a6114f5565b6108e5856007611501565b6108ef9190611501565b6108f99190611547565b8160038151811061090c5761090c611518565b6020908102919091010152606461092483600a6114f5565b61092f856006611501565b6109399190611501565b6109439190611547565b8160048151811061095657610956611518565b6020908102919091010152606461096e83600a6114f5565b610979856005611501565b6109839190611501565b61098d9190611547565b816005815181106109a0576109a0611518565b602090810291909101015260646109b883600a6114f5565b6109c3856004611501565b6109cd9190611501565b6109d79190611547565b8160068151811061022657610226611518565b83600803610c3557600a6109fe83826114f5565b610a09856005611501565b610a139190611501565b610a1d9190611547565b81600081518110610a3057610a30611518565b60209081029190910101526064610a4883600a6114f5565b610a5385600f611501565b610a5d9190611501565b610a679190611547565b81600181518110610a7a57610a7a611518565b6020908102919091010152600a610a9183826114f5565b610a9c856001611501565b610aa69190611501565b610ab09190611547565b81600281518110610ac357610ac3611518565b60209081029190910101526064610adb83600a6114f5565b610ae6856007611501565b610af09190611501565b610afa9190611547565b81600381518110610b0d57610b0d611518565b60209081029190910101526064610b2583600a6114f5565b610b30856006611501565b610b3a9190611501565b610b449190611547565b81600481518110610b5757610b57611518565b60209081029190910101526064610b6f83600a6114f5565b610b7a856005611501565b610b849190611501565b610b8e9190611547565b81600581518110610ba157610ba1611518565b60209081029190910101526064610bb983600a6114f5565b610bc4856004611501565b610bce9190611501565b610bd89190611547565b81600681518110610beb57610beb611518565b60209081029190910101526064610c0383600a6114f5565b610c0e856003611501565b610c189190611501565b610c229190611547565b8160078151811061022657610226611518565b83600903610ecb57600a610c4983826114f5565b610c54856005611501565b610c5e9190611501565b610c689190611547565b81600081518110610c7b57610c7b611518565b60209081029190910101526064610c9383600a6114f5565b610c9e85600f611501565b610ca89190611501565b610cb29190611547565b81600181518110610cc557610cc5611518565b60209081029190910101526064610cdd83600a6114f5565b610ce8856008611501565b610cf29190611501565b610cfc9190611547565b81600281518110610d0f57610d0f611518565b60209081029190910101526064610d2783600a6114f5565b610d32856007611501565b610d3c9190611501565b610d469190611547565b81600381518110610d5957610d59611518565b60209081029190910101526064610d7183600a6114f5565b610d7c856006611501565b610d869190611501565b610d909190611547565b81600481518110610da357610da3611518565b60209081029190910101526064610dbb83600a6114f5565b610dc6856005611501565b610dd09190611501565b610dda9190611547565b81600581518110610ded57610ded611518565b60209081029190910101526064610e0583600a6114f5565b610e10856004611501565b610e1a9190611501565b610e249190611547565b81600681518110610e3757610e37611518565b60209081029190910101526064610e4f83600a6114f5565b610e5a856003611501565b610e649190611501565b610e6e9190611547565b81600781518110610e8157610e81611518565b60209081029190910101526064610e9983600a6114f5565b610ea4856002611501565b610eae9190611501565b610eb89190611547565b8160088151811061022657610226611518565b83600a036111ac57600a610edf83826114f5565b610eea856005611501565b610ef49190611501565b610efe9190611547565b81600081518110610f1157610f11611518565b6020908102919091010152600a610f2883826114f5565b610f33856002611501565b610f3d9190611501565b610f479190611547565b81600181518110610f5a57610f5a611518565b6020908102919091010152600a610f7183826114f5565b610f7c856001611501565b610f869190611501565b610f909190611547565b81600281518110610fa357610fa3611518565b60209081029190910101526064610fbb83600a6114f5565b610fc6856006611501565b610fd09190611501565b610fda9190611547565b81600381518110610fed57610fed611518565b60209081029190910101526103e861100683600a6114f5565b61101185602c611501565b61101b9190611501565b6110259190611547565b8160048151811061103857611038611518565b6020908102919091010152606461105083600a6114f5565b61105b856003611501565b6110659190611501565b61106f9190611547565b8160058151811061108257611082611518565b60209081029190910101526103e861109b83600a6114f5565b6110a6856018611501565b6110b09190611501565b6110ba9190611547565b816006815181106110cd576110cd611518565b60209081029190910101526103e86110e683600a6114f5565b6110f1856016611501565b6110fb9190611501565b6111059190611547565b8160078151811061111857611118611518565b6020908102919091010152606461113083600a6114f5565b61113b856002611501565b6111459190611501565b61114f9190611547565b8160088151811061116257611162611518565b6020908102919091010152606461117a83600a6114f5565b611185856002611501565b61118f9190611501565b6111999190611547565b8160098151811061022657610226611518565b9392505050565b60008273ffffffffffffffffffffffffffffffffffffffff168260405160006040518083038185875af1925050503d806000811461120d576040519150601f19603f3d011682016040523d82523d6000602084013e611212565b606091505b505090508061124d576040517f3f4ab80e00000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b505050565b6000806000806080858703121561126857600080fd5b84356003811061127757600080fd5b966020860135965060408601359560600135945092505050565b6000806000606084860312156112a657600080fd5b505081359360208301359350604090920135919050565b6020808252825182820181905260009190848201906040850190845b818110156112f5578351835292840192918401916001016112d9565b50909695505050505050565b6000806040838503121561131457600080fd5b823573ffffffffffffffffffffffffffffffffffffffff8116811461133857600080fd5b946020939093013593505050565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052602160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052604160045260246000fd5b7f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b600181815b8085111561142c57817fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff04821115611412576114126113a4565b8085161561141f57918102915b93841c93908002906113d8565b509250929050565b600082611443575060016114ef565b81611450575060006114ef565b816001811461146657600281146114705761148c565b60019150506114ef565b60ff841115611481576114816113a4565b50506001821b6114ef565b5060208310610133831016604e8410600b84101617156114af575081810a6114ef565b6114b983836113d3565b807fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff048211156114eb576114eb6113a4565b0290505b92915050565b60006111ac8383611434565b80820281158282048414176114ef576114ef6113a4565b7f4e487b7100000000000000000000000000000000000000000000000000000000600052603260045260246000fd5b60008261157d577f4e487b7100000000000000000000000000000000000000000000000000000000600052601260045260246000fd5b50049056fea2646970667358221220575e93a173c440ddf9e8c6c3411ac7def61e6f05f5069d04df525364597a2bc364736f6c63430008110033";

type BTCLCoreFixedConstructorParams =
  | [signer?: Signer]
  | ConstructorParameters<typeof ContractFactory>;

const isSuperArgs = (
  xs: BTCLCoreFixedConstructorParams
): xs is ConstructorParameters<typeof ContractFactory> => xs.length > 1;

export class BTCLCoreFixed__factory extends ContractFactory {
  constructor(...args: BTCLCoreFixedConstructorParams) {
    if (isSuperArgs(args)) {
      super(...args);
    } else {
      super(_abi, _bytecode, args[0]);
    }
  }

  override deploy(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<BTCLCoreFixed> {
    return super.deploy(overrides || {}) as Promise<BTCLCoreFixed>;
  }
  override getDeployTransaction(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): TransactionRequest {
    return super.getDeployTransaction(overrides || {});
  }
  override attach(address: string): BTCLCoreFixed {
    return super.attach(address) as BTCLCoreFixed;
  }
  override connect(signer: Signer): BTCLCoreFixed__factory {
    return super.connect(signer) as BTCLCoreFixed__factory;
  }

  static readonly bytecode = _bytecode;
  static readonly abi = _abi;
  static createInterface(): BTCLCoreFixedInterface {
    return new utils.Interface(_abi) as BTCLCoreFixedInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): BTCLCoreFixed {
    return new Contract(address, _abi, signerOrProvider) as BTCLCoreFixed;
  }
}
