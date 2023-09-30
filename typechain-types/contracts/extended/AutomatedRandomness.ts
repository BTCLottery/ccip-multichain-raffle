/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */
import type {
  BaseContract,
  BigNumber,
  BigNumberish,
  BytesLike,
  CallOverrides,
  ContractTransaction,
  Overrides,
  PopulatedTransaction,
  Signer,
  utils,
} from "ethers";
import type { FunctionFragment, Result } from "@ethersproject/abi";
import type { Listener, Provider } from "@ethersproject/providers";
import type {
  TypedEventFilter,
  TypedEvent,
  TypedListener,
  OnEvent,
  PromiseOrValue,
} from "../../common";

export interface AutomatedRandomnessInterface extends utils.Interface {
  functions: {
    "COORDINATOR()": FunctionFragment;
    "LINKToken()": FunctionFragment;
    "callbackGasLimit()": FunctionFragment;
    "keyHash()": FunctionFragment;
    "manager()": FunctionFragment;
    "pause()": FunctionFragment;
    "paused()": FunctionFragment;
    "rawFulfillRandomWords(uint256,uint256[])": FunctionFragment;
    "requestConfirmations()": FunctionFragment;
    "setGasLimit(uint32)": FunctionFragment;
    "setMinBlockLimit(uint16)": FunctionFragment;
    "subscriptionId()": FunctionFragment;
    "transferManager(address)": FunctionFragment;
    "unpause()": FunctionFragment;
    "withdrawLink(address)": FunctionFragment;
  };

  getFunction(
    nameOrSignatureOrTopic:
      | "COORDINATOR"
      | "LINKToken"
      | "callbackGasLimit"
      | "keyHash"
      | "manager"
      | "pause"
      | "paused"
      | "rawFulfillRandomWords"
      | "requestConfirmations"
      | "setGasLimit"
      | "setMinBlockLimit"
      | "subscriptionId"
      | "transferManager"
      | "unpause"
      | "withdrawLink"
  ): FunctionFragment;

  encodeFunctionData(
    functionFragment: "COORDINATOR",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "LINKToken", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "callbackGasLimit",
    values?: undefined
  ): string;
  encodeFunctionData(functionFragment: "keyHash", values?: undefined): string;
  encodeFunctionData(functionFragment: "manager", values?: undefined): string;
  encodeFunctionData(functionFragment: "pause", values?: undefined): string;
  encodeFunctionData(functionFragment: "paused", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "rawFulfillRandomWords",
    values: [PromiseOrValue<BigNumberish>, PromiseOrValue<BigNumberish>[]]
  ): string;
  encodeFunctionData(
    functionFragment: "requestConfirmations",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "setGasLimit",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "setMinBlockLimit",
    values: [PromiseOrValue<BigNumberish>]
  ): string;
  encodeFunctionData(
    functionFragment: "subscriptionId",
    values?: undefined
  ): string;
  encodeFunctionData(
    functionFragment: "transferManager",
    values: [PromiseOrValue<string>]
  ): string;
  encodeFunctionData(functionFragment: "unpause", values?: undefined): string;
  encodeFunctionData(
    functionFragment: "withdrawLink",
    values: [PromiseOrValue<string>]
  ): string;

  decodeFunctionResult(
    functionFragment: "COORDINATOR",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "LINKToken", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "callbackGasLimit",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "keyHash", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "manager", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "pause", data: BytesLike): Result;
  decodeFunctionResult(functionFragment: "paused", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "rawFulfillRandomWords",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "requestConfirmations",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setGasLimit",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "setMinBlockLimit",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "subscriptionId",
    data: BytesLike
  ): Result;
  decodeFunctionResult(
    functionFragment: "transferManager",
    data: BytesLike
  ): Result;
  decodeFunctionResult(functionFragment: "unpause", data: BytesLike): Result;
  decodeFunctionResult(
    functionFragment: "withdrawLink",
    data: BytesLike
  ): Result;

  events: {};
}

export interface AutomatedRandomness extends BaseContract {
  connect(signerOrProvider: Signer | Provider | string): this;
  attach(addressOrName: string): this;
  deployed(): Promise<this>;

  interface: AutomatedRandomnessInterface;

  queryFilter<TEvent extends TypedEvent>(
    event: TypedEventFilter<TEvent>,
    fromBlockOrBlockhash?: string | number | undefined,
    toBlock?: string | number | undefined
  ): Promise<Array<TEvent>>;

  listeners<TEvent extends TypedEvent>(
    eventFilter?: TypedEventFilter<TEvent>
  ): Array<TypedListener<TEvent>>;
  listeners(eventName?: string): Array<Listener>;
  removeAllListeners<TEvent extends TypedEvent>(
    eventFilter: TypedEventFilter<TEvent>
  ): this;
  removeAllListeners(eventName?: string): this;
  off: OnEvent<this>;
  on: OnEvent<this>;
  once: OnEvent<this>;
  removeListener: OnEvent<this>;

  functions: {
    COORDINATOR(overrides?: CallOverrides): Promise<[string]>;

    LINKToken(overrides?: CallOverrides): Promise<[string]>;

    callbackGasLimit(overrides?: CallOverrides): Promise<[number]>;

    keyHash(overrides?: CallOverrides): Promise<[string]>;

    manager(overrides?: CallOverrides): Promise<[string]>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    paused(overrides?: CallOverrides): Promise<[boolean]>;

    rawFulfillRandomWords(
      requestId: PromiseOrValue<BigNumberish>,
      randomWords: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    requestConfirmations(overrides?: CallOverrides): Promise<[number]>;

    setGasLimit(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    setMinBlockLimit(
      _blocks: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    subscriptionId(overrides?: CallOverrides): Promise<[BigNumber]>;

    transferManager(
      newManager: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;

    withdrawLink(
      receiverAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<ContractTransaction>;
  };

  COORDINATOR(overrides?: CallOverrides): Promise<string>;

  LINKToken(overrides?: CallOverrides): Promise<string>;

  callbackGasLimit(overrides?: CallOverrides): Promise<number>;

  keyHash(overrides?: CallOverrides): Promise<string>;

  manager(overrides?: CallOverrides): Promise<string>;

  pause(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  paused(overrides?: CallOverrides): Promise<boolean>;

  rawFulfillRandomWords(
    requestId: PromiseOrValue<BigNumberish>,
    randomWords: PromiseOrValue<BigNumberish>[],
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  requestConfirmations(overrides?: CallOverrides): Promise<number>;

  setGasLimit(
    _amount: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  setMinBlockLimit(
    _blocks: PromiseOrValue<BigNumberish>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  subscriptionId(overrides?: CallOverrides): Promise<BigNumber>;

  transferManager(
    newManager: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  unpause(
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  withdrawLink(
    receiverAddress: PromiseOrValue<string>,
    overrides?: Overrides & { from?: PromiseOrValue<string> }
  ): Promise<ContractTransaction>;

  callStatic: {
    COORDINATOR(overrides?: CallOverrides): Promise<string>;

    LINKToken(overrides?: CallOverrides): Promise<string>;

    callbackGasLimit(overrides?: CallOverrides): Promise<number>;

    keyHash(overrides?: CallOverrides): Promise<string>;

    manager(overrides?: CallOverrides): Promise<string>;

    pause(overrides?: CallOverrides): Promise<void>;

    paused(overrides?: CallOverrides): Promise<boolean>;

    rawFulfillRandomWords(
      requestId: PromiseOrValue<BigNumberish>,
      randomWords: PromiseOrValue<BigNumberish>[],
      overrides?: CallOverrides
    ): Promise<void>;

    requestConfirmations(overrides?: CallOverrides): Promise<number>;

    setGasLimit(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    setMinBlockLimit(
      _blocks: PromiseOrValue<BigNumberish>,
      overrides?: CallOverrides
    ): Promise<void>;

    subscriptionId(overrides?: CallOverrides): Promise<BigNumber>;

    transferManager(
      newManager: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;

    unpause(overrides?: CallOverrides): Promise<void>;

    withdrawLink(
      receiverAddress: PromiseOrValue<string>,
      overrides?: CallOverrides
    ): Promise<void>;
  };

  filters: {};

  estimateGas: {
    COORDINATOR(overrides?: CallOverrides): Promise<BigNumber>;

    LINKToken(overrides?: CallOverrides): Promise<BigNumber>;

    callbackGasLimit(overrides?: CallOverrides): Promise<BigNumber>;

    keyHash(overrides?: CallOverrides): Promise<BigNumber>;

    manager(overrides?: CallOverrides): Promise<BigNumber>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    paused(overrides?: CallOverrides): Promise<BigNumber>;

    rawFulfillRandomWords(
      requestId: PromiseOrValue<BigNumberish>,
      randomWords: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    requestConfirmations(overrides?: CallOverrides): Promise<BigNumber>;

    setGasLimit(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    setMinBlockLimit(
      _blocks: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    subscriptionId(overrides?: CallOverrides): Promise<BigNumber>;

    transferManager(
      newManager: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;

    withdrawLink(
      receiverAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<BigNumber>;
  };

  populateTransaction: {
    COORDINATOR(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    LINKToken(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    callbackGasLimit(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    keyHash(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    manager(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    pause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    paused(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    rawFulfillRandomWords(
      requestId: PromiseOrValue<BigNumberish>,
      randomWords: PromiseOrValue<BigNumberish>[],
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    requestConfirmations(
      overrides?: CallOverrides
    ): Promise<PopulatedTransaction>;

    setGasLimit(
      _amount: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    setMinBlockLimit(
      _blocks: PromiseOrValue<BigNumberish>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    subscriptionId(overrides?: CallOverrides): Promise<PopulatedTransaction>;

    transferManager(
      newManager: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    unpause(
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;

    withdrawLink(
      receiverAddress: PromiseOrValue<string>,
      overrides?: Overrides & { from?: PromiseOrValue<string> }
    ): Promise<PopulatedTransaction>;
  };
}
