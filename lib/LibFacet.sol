// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "solady/utils/LibRLP.sol";

library LibFacet {
    using LibRLP for LibRLP.List;
    
    address constant facetInboxAddress = 0x00000000000000000000000000000000000FacE7;
    
    function sendFacetTransaction(
        address to,
        uint256 value,
        uint256 maxFeePerGas,
        uint256 gasLimit,
        bytes memory data
    ) internal {
        sendFacetTransaction(abi.encodePacked(to), value, maxFeePerGas, gasLimit, data);
    }

    function sendFacetTransaction(
        bytes memory to,
        uint256 value,
        uint256 maxFeePerGas,
        uint256 gasLimit,
        bytes memory data
    ) internal {
        uint256 chainId;
        
        if (block.chainid == 1) {
            chainId = 0xface7;
        } else if (block.chainid == 11155111) {
            chainId = 0xface7a;
        } else {
            revert("Unsupported chainId");
        }
        
        uint8 facetTxType = 70;

        LibRLP.List memory list;

        list.p(chainId);
        list.p(to);
        list.p(value);
        list.p(maxFeePerGas);
        list.p(gasLimit);
        list.p(data);
        
        bytes memory out = abi.encodePacked(facetTxType, list.encode());

        (bool success,) = facetInboxAddress.call(out);

        require(success, "call failed");
    }
}