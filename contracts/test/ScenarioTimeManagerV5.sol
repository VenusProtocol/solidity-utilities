// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.5.16;

import { TimeManagerV5 } from "../TimeManagerV5.sol";

contract ScenarioTimeManagerV5 is TimeManagerV5 {
    function initializeTimeManager(bool timeBased_, uint256 blocksPerYear_) external {
        _initializeTimeManager(timeBased_, blocksPerYear_);
    }
}
