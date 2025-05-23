// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.5.16;

/**
 * @title TimeManagerV5
 * @dev THIS CONTRACT IS NOT MEANT TO BE DEPLOYED DIRECTLY.
 * It should only be used through inheritance by other contracts.
 */
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
     *
     * Storage layout explanation:
     * - blocksOrSecondsPerYear (uint256): Occupies slot 0 (full 32 bytes)
     * - Slot 1 has the following variables packed from right to left (low to high):
     *   - isTimeBased (bool): 1 byte at lowest position
     *   - isInitialized (bool): 1 byte
     *   - __deprecatedSlot1 (bytes8): 8 bytes
     *
     * Total used slots: 2
     * Therefore __gap size is 48 (50 - 2 = 48)
     */

    uint256[48] private __gap;

    /// @notice Emitted once Time Manager is initialized with timebased and blocksOrSecondsPerYear
    event InitializeTimeManager(bool indexed timebased, uint256 indexed blocksOrSecondsPerYear);

    /// @notice Emitted When blocks per year is updated for block based network
    event SetBlocksPerYear(uint256 indexed prevBlocksPerYear, uint256 indexed newBlocksPerYear);

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

        isInitialized = true;
        isTimeBased = timeBased_;
        blocksOrSecondsPerYear = timeBased_ ? SECONDS_PER_YEAR : blocksPerYear_;
        emit InitializeTimeManager(isTimeBased, blocksOrSecondsPerYear);
    }

    /**
     * @dev Set blocks per year for block based network
     * @param blocksPerYear_ The number of blocks per year
     */
    function _setBlocksPerYear(uint256 blocksPerYear_) internal {
        if (blocksPerYear_ == 0) {
            revert("Blocks per year cannot be zero");
        }

        if (isTimeBased) {
            revert("Cannot update for time based network");
        }
        emit SetBlocksPerYear(blocksOrSecondsPerYear, blocksPerYear_);
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
