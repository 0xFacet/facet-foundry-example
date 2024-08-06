// script/Deploy.s.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "lib/LibFacet.sol";
import "../src/SimpleStorage.sol";
import "solady/utils/LibRLP.sol";
import "solady/utils/LibString.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast(vm.envUint("PRIVATE_KEY"));
        
        LibFacet.sendFacetTransaction(
          {
            to: bytes(''),
            value: 0,
            maxFeePerGas: 10,
            gasLimit: 500_000,
            data: type(SimpleStorage).creationCode
          }
        );
        
        vm.stopBroadcast();
    }
}
