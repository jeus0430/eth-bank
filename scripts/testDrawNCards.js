import ethers from "ethers";
// import chalk from "chalk";

const API_KEY = process.env.NODE_KEY;
const MNEMONIC = process.env.MNEMONIC;
const MUMBAI = `https://rpc-mumbai.maticvigil.com/v1/${API_KEY}`;
const CONTRACT = "0x2Ad49c915E09792B23767Cd4A24Ba53e6Ba10563";

// const mainnetUrl =
//     "https://ropsten.infura.io/v3/ae7e51244f7141848b377da95a776361";

const provider = new ethers.providers.JsonRpcProvider(MUMBAI);

var wallet = ethers.Wallet.fromMnemonic(MNEMONIC);
const account = wallet.connect(provider);

const randomContract = new ethers.Contract(
    CONTRACT,
    [
        "event OnDrawNCards(uint256[] cards)",
        "function drawNCards(uint256 n) public",
    ],
    account
);

const testDrawN = async () => {
    randomContract.once("OnDrawNCards", async (cards) => {
        // console.log(chalk.blue(cards));
        console.log(cards);
    });
    const tx = await randomContract.drawNCards(7);
    console.log(JSON.stringify(tx));
};

testDrawN();
