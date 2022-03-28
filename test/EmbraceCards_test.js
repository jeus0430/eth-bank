require("dotenv").config()
const EmbraceCards = artifacts.require("EmbraceCards")

const { BigNumber } = require("ethers")
const { assert } = require("./setup_chai")

const waitUntilTransactionsMined = (txn_hashes) => {
  var transactionReceiptAsync
  const interval = 500
  transactionReceiptAsync = function (txn_hashes, resolve, reject) {
    try {
      var receipt = web3.eth.getTransactionReceipt(txn_hashes)
      if (receipt == null) {
        setTimeout(function () {
          transactionReceiptAsync(txn_hashes, resolve, reject)
        }, interval)
      } else {
        resolve(receipt)
      }
    } catch (e) {
      reject(e)
    }
  }

  if (Array.isArray(txn_hashes)) {
    var promises = []
    txn_hashes.forEach(function (tx_hash) {
      promises.push(waitUntilTransactionsMined(tx_hash))
    })
    return Promise.all(promises)
  } else {
    return new Promise(function (resolve, reject) {
      transactionReceiptAsync(txn_hashes, resolve, reject)
    })
  }
}

const accounts = [
  '0x350627F65e2492CACDfA0c4769CCD07Da736c2f6',
  '0xd2441eE28A4C38383920cFaa6202FdD9672B8aA1',
  '0xB82926b21183a781C1194D048Ee3C27f0858A56a',
  '0x870d595Ba478b7AD1F16b3b405a25357b8e62F32',
  '0xfE05c8463e62E43Bf657c4CA806662573ECE6206',
  '0xC00e3E450DB517cab33595A7E405385d7a5275b3',
  '0x5a0266EfE63F16628E124c578d91829a43795a69',
  '0xCA0A3B9549fA1a40075e837Bb83a21178f92324D',
  '0x3B769a45af7ad13e4d92e9dF503D024029C64Bc6',
  '0xEF3E62866f419f8bfffd29Dc9df4d2b8d9AAee29'
]
async () => {
  const [deployer] = accounts
  console.log("accounts", accounts)
  console.log("deployer", deployer)
  const mintCount = 1;
  const ascendingArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]

  describe("Ownership", async () => {
    it("of the contract initially belong to contract caller", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      let owner = await instance.owner.call()
      console.log('owner', owner);
      assert.equal(owner, deployer, "Oops, what happens? contract owner has changed?")
    })
  })

  describe("generation", async () => {
    it("Makes new generation", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      console.log(":P make generation with 20 items");
      tx = await instance.makeNewGeneration.call(20, {
        from: deployer, gas: 20000000000000000, value: BigNumber.from('100000000100000000')
      })
      // await waitUntilTransactionsMined(tx.tx)

      console.log(":o make generation");
      // let totalAccounts = instance._totalSupply.call()
      // console.log(":x");
      // assert.equal(totalAccounts, mintCount)
    })
  })

  describe("Minting", async () => {
    it("Batch minting is working", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      console.log(":P");
      tx = await instance.mint.call(deployer, mintCount, {
        from: deployer, gas: 2000000000000000, value: BigNumber.from('100000000100000000')
      })
      await waitUntilTransactionsMined(tx.tx)

      console.log(":o");
      let totalAccounts = instance._totalSupply.call()
      console.log(":x");
      assert.equal(totalAccounts, mintCount)
    })
  })
}
contract("EmbraceCards tests", async (accounts) => {
  const [deployer] = accounts
  console.log("accounts", accounts)
  console.log("deployer", deployer)
  const mintCount = 20;
  const ascendingArray = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]

  describe("Ownership", async () => {
    it("of the contract initially belong to contract caller", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      let owner = await instance.owner.call()
      console.log('owner', owner);
      assert.equal(owner, deployer, "Oops, what happens? contract owner has changed?")
    })
  })

  describe("generation", async () => {
    it("Makes new generation", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      console.log(":P make generation with 20 items");
      tx = await instance.makeNewGeneration.call(20, {
        from: deployer, gas: 20000000000000000, value: BigNumber.from('100000000100000000')
      })
      // await waitUntilTransactionsMined(tx.tx)

      console.log(":o make generation");
      // let totalAccounts = instance._totalSupply.call()
      // console.log(":x");
      // assert.equal(totalAccounts, mintCount)
    })
  })

  describe("Minting", async () => {
    it("Batch minting is working", async () => {
      let instance = await EmbraceCards.deployed()
      console.log('deployed address', instance.address);

      console.log(":P");
      tx = await instance.mint.call(deployer, mintCount, {
        from: deployer, gas: 500000, value: BigNumber.from('100000000100000000')
      });
      // await waitUntilTransactionsMined(tx.tx)

      console.log(":o");
      let totalAccounts = instance._totalSupply.call()
      console.log(":x");
      assert.equal(totalAccounts, mintCount)
    })
  })

  // describe("Random Minting", async () => {
  //   it("Random logic is working", async () => {
  //     let instance = await EmbraceCards.deployed()
  //     console.log('deployed address', instance.address);
  //
  //     await instance.mint(deployer, mintCount).call()
  //     let tokenIds = await instance.getTokenIdsOfWallet(deployer).call()
  //     console.log(tokenIds);
  //     assert.equal(tokenIds, ascendingArray, "Congrats!, token ids are in random array")
  //   })
  // })
})
