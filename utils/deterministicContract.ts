import { ethers } from "ethers"

const factoryAddress = "0x28a70cD40b706f2EE2F959ab8d83Bf86BcF57716"; // Your deployed factory contract address
const leadingZeroes = 3; // Number of leading zeroes desired in the address
const bytecode =
  "0x608060405234801561001057600080fd5b50600080546001600160a01b031916331790556103ce806100326000396000f3fe608060405234801561001057600080fd5b50600436106100725760003560e01c80638da5cb5b116100505780638da5cb5b146100db578063953d0d4a14610120578063f2fde38b1461013357600080fd5b80630a5936f11461007757806350d87c4d1461008157806367e2efc6146100a5575b600080fd5b61007f610146565b005b336000908152600160205260409020545b6040519081526020015b60405180910390f35b6100926100b33660046102ec565b73ffffffffffffffffffffffffffffffffffffffff1660009081526001602052604090205490565b6000546100fb9073ffffffffffffffffffffffffffffffffffffffff1681565b60405173ffffffffffffffffffffffffffffffffffffffff909116815260200161009c565b61007f61012e36600461030e565b610168565b61007f6101413660046102ec565b6101f2565b33600090815260016020526040812080549161016183610338565b9190505550565b60005473ffffffffffffffffffffffffffffffffffffffff16331461018c57600080fd5b73ffffffffffffffffffffffffffffffffffffffff821660008181526001602052604090819020839055517f9cc517ce7acb71ad9ec187ef88ff5fead0d984288c1bafe36aa97f90ffb65ae6906101e69084815260200190565b60405180910390a25050565b60005473ffffffffffffffffffffffffffffffffffffffff16331461021657600080fd5b73ffffffffffffffffffffffffffffffffffffffff811661023657600080fd5b6000805460405173ffffffffffffffffffffffffffffffffffffffff808516939216917f8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e091a3600080547fffffffffffffffffffffffff00000000000000000000000000000000000000001673ffffffffffffffffffffffffffffffffffffffff92909216919091179055565b803573ffffffffffffffffffffffffffffffffffffffff811681146102e757600080fd5b919050565b6000602082840312156102fe57600080fd5b610307826102c3565b9392505050565b6000806040838503121561032157600080fd5b61032a836102c3565b946020939093013593505050565b60007fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff821415610391577f4e487b7100000000000000000000000000000000000000000000000000000000600052601160045260246000fd5b506001019056fea26469706673582212207a70a474576cfff069ecb082e491aa3522b70e6fd9a7daceeb794daf1fcf782464736f6c63430008090033"; // Your bytecode
const msgSender = "0xCf7be84148Db4Ff426f57e229bAc513ba656894c";

const createDeterministicContract = async (_factoryAddress: string, _bytecode: string, _msgSender: string, _leadingZeros: number) => {
  console.time();
  let salt;
  let i = 0;
  while (!salt) {
    const saltBytes = ethers.utils.randomBytes(12);
    const msgSenderBytes = ethers.utils.arrayify(_msgSender);
    const fullSaltBytes = ethers.utils.concat([msgSenderBytes, saltBytes]);
    const saltHex = saltBytes.toString();
    const bytecodeBytes = ethers.utils.arrayify(_bytecode);
    const initCodeHash = ethers.utils.keccak256(bytecodeBytes);
    const addr = ethers.utils.getCreate2Address(
      _factoryAddress,
      fullSaltBytes,
      initCodeHash
    );
    console.log("adddr", addr, i);
    if (addr.slice(2, 2 + _leadingZeros) === "0".repeat(_leadingZeros)) {
      salt = ethers.utils.hexlify(fullSaltBytes);
      console.log(`Salt: ${salt}, ${saltBytes}, ${saltHex} Address: ${addr}`);
      console.timeEnd();
      return salt;
      // break;
    }
    i++;
  }

  process.removeAllListeners();
};

export default createDeterministicContract;