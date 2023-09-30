/* Autogenerated file. Do not edit manually. */
/* tslint:disable */
/* eslint-disable */

import { Contract, Signer, utils } from "ethers";
import type { Provider } from "@ethersproject/providers";
import type {
  WhitelistManager,
  WhitelistManagerInterface,
} from "../../../contracts/extended/WhitelistManager";

const _abi = [
  {
    inputs: [],
    name: "ADDRESS_ZERO",
    type: "error",
  },
  {
    inputs: [],
    name: "NOT_MANAGER",
    type: "error",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    name: "isWhitelisted",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "manager",
    outputs: [
      {
        internalType: "address",
        name: "",
        type: "address",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "pause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "paused",
    outputs: [
      {
        internalType: "bool",
        name: "",
        type: "bool",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_playerAddress",
        type: "address",
      },
      {
        internalType: "bool",
        name: "_isWhitelisted",
        type: "bool",
      },
    ],
    name: "setWhitelist",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "newManager",
        type: "address",
      },
    ],
    name: "transferManager",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [],
    name: "unpause",
    outputs: [],
    stateMutability: "nonpayable",
    type: "function",
  },
] as const;

export class WhitelistManager__factory {
  static readonly abi = _abi;
  static createInterface(): WhitelistManagerInterface {
    return new utils.Interface(_abi) as WhitelistManagerInterface;
  }
  static connect(
    address: string,
    signerOrProvider: Signer | Provider
  ): WhitelistManager {
    return new Contract(address, _abi, signerOrProvider) as WhitelistManager;
  }
}