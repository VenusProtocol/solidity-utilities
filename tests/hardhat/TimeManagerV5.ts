import chai from "chai";
import { ethers } from "hardhat";

const { expect } = chai;

describe("TimeManagerV5: tests", async () => {
  let timeManager: ethers.Contracts;
  describe("For block number", async () => {
    const blocksPerYear = 10512000;
    beforeEach(async () => {
      const timeManagerV5 = await ethers.getContractFactory("ScenarioTimeManagerV5");
      timeManager = await timeManagerV5.deploy();
      await timeManager.initializeTimeManager(false, blocksPerYear);
    });

    it("Retrieves block timestamp", async () => {
      const currentBlockNumber = (await ethers.provider.getBlock("latest")).number;
      expect(await timeManager.getBlockNumberOrTimestamp()).to.be.equal(currentBlockNumber);
      expect(await timeManager.blocksOrSecondsPerYear()).to.be.equal(blocksPerYear);
    });
  });
  describe("For block timestamp", async () => {
    beforeEach(async () => {
      const timeManagerV5 = await ethers.getContractFactory("ScenarioTimeManagerV5");
      timeManager = await timeManagerV5.deploy();
      await timeManager.initializeTimeManager(true, 0);
    });

    it("Retrieves block timestamp", async () => {
      const secondsPerYear = await timeManager.SECONDS_PER_YEAR();
      const currentBlocktimestamp = (await ethers.provider.getBlock("latest")).timestamp;
      expect(await timeManager.getBlockNumberOrTimestamp()).to.be.equal(currentBlocktimestamp);
      expect(await timeManager.blocksOrSecondsPerYear()).to.be.equal(secondsPerYear);
    });
  });
});
