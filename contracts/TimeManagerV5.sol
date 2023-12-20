// SPDX-License-Identifier: BSD-3-Clause
pragma solidity 0.5.16;

contract TimeManagerV5 {
    /// @dev The approximate number of seconds per year
    uint256 public constant SECONDS_PER_YEAR = 31_536_000;

    /// @notice Number of blocks per year or seconds per year
    uint256 public blocksOrSecondsPerYear;

    /// @dev Sets true when block timestamp is used
    bool public isTimeBased;

    /**
     * @dev Retrieves the current slot
     * @return Current slot
     */
    function() view returns (uint256) private _getCurrentSlot;

    /**
     * @param timeBased_ A boolean indicating whether the contract is based on time or block.
     * If timeBased is true than blocksPerYear_ param is ignored as blocksOrSecondsPerYear is set to SECONDS_PER_YEAR
     * @param blocksPerYear_ The number of blocks per year
     */
    constructor(bool timeBased_, uint256 blocksPerYear_) public {
        if (!timeBased_ && blocksPerYear_ == 0) {
            revert("Invalid blocks per year");
        }
        if (timeBased_ && blocksPerYear_ != 0) {
            revert("Invalid time based");
        }

        isTimeBased = timeBased_;
        blocksOrSecondsPerYear = timeBased_ ? SECONDS_PER_YEAR : blocksPerYear_;
        _getCurrentSlot = timeBased_ ? _getBlockTimestamp : _getBlockNumber;
    }

    /**
     * @dev Function to simply retrieve block number or block timestamp
     * @return Current block number or block timestamp
     */
    function getBlockNumberOrTimestamp() public view returns (uint256) {
        return _getCurrentSlot();
    }

    /**
     * @notice Returns the current timestamp in seconds
     * @return The current timestamp
     */
    function _getBlockTimestamp() private view returns (uint256) {
        return block.timestamp;
    }

    /**
     * @notice Returns the current block number
     * @return The current block number
     */
    function _getBlockNumber() private view returns (uint256) {
        return block.number;
    }
}
