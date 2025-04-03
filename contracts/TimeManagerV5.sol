// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.5.16;

contract TimeManagerV5 {
    /// @dev The approximate number of seconds per year
    uint256 public constant SECONDS_PER_YEAR = 31_536_000;

    /// @notice Number of blocks per year or seconds per year
    uint256 public blocksOrSecondsPerYear;

    /// @dev Sets true when block timestamp is used
    bool public isTimeBased;

    /// @dev Sets true when contract is initialized
    bool private isInitialized;

    /// @notice Deprecated slot for _getCurrentSlot function pointer
    bytes8 private __deprecatedSlot1;

    /**
     * @dev This empty reserved space is put in place to allow future versions to add new
     * variables without shifting down storage in the inheritance chain
     * See https://docs.openzeppelin.com/contracts/4.x/upgradeable#storage_gaps
     */
    uint256[48] private __gap;

    /**
     * @dev Function to simply retrieve block number or block timestamp
     * @return Current block number or block timestamp
     */
    function getBlockNumberOrTimestamp() public view returns (uint256) {
        return isTimeBased ? _getBlockTimestamp() : _getBlockNumber();
    }

    /**
     * @dev Initializes the contract to use either blocks or seconds
     * @param timeBased_ A boolean indicating whether the contract is based on time or block
     * If timeBased is true than blocksPerYear_ param is ignored as blocksOrSecondsPerYear is set to SECONDS_PER_YEAR
     * @param blocksPerYear_ The number of blocks per year
     */
    function _initializeTimeManager(bool timeBased_, uint256 blocksPerYear_) internal {
        if (isInitialized) revert("Already initialized TimeManager");

        if (!timeBased_ && blocksPerYear_ == 0) {
            revert("Invalid blocks per year");
        }
        if (timeBased_ && blocksPerYear_ != 0) {
            revert("Invalid time based configuration");
        }

        isTimeBased = timeBased_;
        blocksOrSecondsPerYear = timeBased_ ? SECONDS_PER_YEAR : blocksPerYear_;
        isInitialized = true;
    }

    /**
     * @dev Set blocks per year
     * @param blocksPerYear_ The number of blocks per year
     */
    function _setBlocksPerYear(uint256 blocksPerYear_) internal {
        if (blocksPerYear_ == 0 && !isTimeBased) {
            revert("Invalid blocks per year");
        }
        blocksOrSecondsPerYear = blocksPerYear_;
    }

    /**
     * @dev Returns the current timestamp in seconds
     * @return The current timestamp
     */
    function _getBlockTimestamp() private view returns (uint256) {
        return block.timestamp;
    }

    /**
     * @dev Returns the current block number
     * @return The current block number
     */
    function _getBlockNumber() private view returns (uint256) {
        return block.number;
    }
}
