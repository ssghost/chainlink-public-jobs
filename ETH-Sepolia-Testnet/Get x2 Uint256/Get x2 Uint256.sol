// SPDX-License-Identifier: MIT
// https://glink.solutions
// Discord=https://discord.gg/KmZVYhYJUy

/**
 * THIS IS AN EXAMPLE CONTRACT WHICH USES HARDCODED VALUES FOR CLARITY.
 * THIS EXAMPLE USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */

pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract getMultiVariableTemplate is ChainlinkClient, ConfirmedOwner {
  using Chainlink for Chainlink.Request;

  bytes32 private externalJobId;
  uint256 private oraclePayment;

  uint256 public Value2;
  uint256 public Value1;

  constructor() ConfirmedOwner(msg.sender){
  setChainlinkToken(0x779877A7B0D9E8603169DdbD7836e478b4624789);
  setChainlinkOracle(0x6c2e87340Ef6F3b7e21B2304D6C057091814f25E);
  externalJobId = "e35ba51d6ac14220b2e5554e5e1a97a5";
  oraclePayment = ((0 * LINK_DIVISIBILITY) / 10); // n * 10**18
  }

  function requestValue1AndValue2()
    public
    onlyOwner
  {
    Chainlink.Request memory req = buildChainlinkRequest(externalJobId, address(this), this.fulfillValue1AndValue2.selector);
    req.add("get", "https://your_API_endpoint_url");
    req.add("path1", "data,results1");
    req.add("path2", "data,results2");
    req.addInt("times", 100);
    sendOperatorRequest(req, oraclePayment);
  }

  event RequestFulfilledValue1AndValue2(bytes32 indexed requestId, uint256 indexed Value2, uint256 indexed Value1);

  function fulfillValue1AndValue2(bytes32 requestId, uint256 _Value2, uint256 _Value1)
    public
    recordChainlinkFulfillment(requestId)
  {
    emit RequestFulfilledValue1AndValue2(requestId, _Value2, _Value1);
    Value1 = _Value1;
    Value2 = _Value2;
  }

}
