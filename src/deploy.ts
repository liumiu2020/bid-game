import {ethers} from "hardhat";

async function main() {
    const bidFactory = await ethers.getContractFactory("Bid");
    const bid = await bidFactory.deploy([{
        id: 1,
        name: "book",
        category: 2
    }], 3600);
    await bid.deployed();
    console.log("bid addr:", bid.address);

    const transferFactory = await ethers.getContractFactory("Transfer");
    const transfer = await transferFactory.deploy();
    await transfer.deployed();
    console.log("transfer addr:", transfer.address);

    const bookFactory = await ethers.getContractFactory("Book");
    const book = await bookFactory.deploy();
    await book.deployed();
    console.log("book addr:", book.address);

    const goldOrcFactory = await ethers.getContractFactory("GoldOrc");
    const goldOrc = await goldOrcFactory.deploy();
    await goldOrc.deployed();
    const goldOrcAddr = goldOrc.address;
    console.log("goldOrc addr:", goldOrcAddr);

    const goldFactory = await ethers.getContractFactory("Gold");
    const gold = await goldFactory.deploy(goldOrcAddr);
    await gold.deployed();
    console.log("gold addr:", book.address);

    const gameOrcFactory = await ethers.getContractFactory("GameOrc");
    const gameOrc = await gameOrcFactory.deploy();
    await gameOrc.deployed();
    const gameOrcAddr = gameOrc.address;
    console.log("gameOrc addr:", gameOrcAddr);

    const gameFactory = await ethers.getContractFactory("Game");
    const game = await gameFactory.deploy(gameOrcAddr);
    await game.deployed();
    console.log("game addr:", game.address);
}

//last deployed Bid 0xDA20a8F646e3288C6505300074BB3787705b9E1f
/*
 *transfer addr: 0x983373573882E29D86956dDAdE34586a84012Db1
book addr: 0xAb3B467dB70e99342fbF47de6AD74A1371518e20
goldOrc addr: 0x6C8e0275024f5CE14cD54d750E0071fcE4385f47
gold addr: 0xE833ccD3bb40c936fb17A2E2f7d4B2387197a520
gameOrc addr: 0x09B2310c2d50269e9Afe8f0a6489cdecB1E6F779
game addr: 0xE24f38384E010f0495048fC159c9340B43c8de0f
 */
main().catch((error) => {
    console.error(error);
    process.exit(1);
});