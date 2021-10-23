const main = async() => {
	// compiles the smart contract and generate necesaary files under aritfacts directoy
	const nftContractFactory = await hre.ethers.getContractFactory('MyEpicNFT');

	//hardhat creates a local blockchain for this contract and destroys it after the script is complete
	const nftContract = await nftContractFactory.deploy();

	//waiting for the contract to be be mined and deployed to the chain ; Our constructor runs right after we have deployed the contract.
	await nftContract.deployed();

	//gives us the address of the deployed contract ,comes in handy when deploy to real chain.
	console.log("Contract deployed to " + nftContract.address);

	//call the function
	let txn = await nftContract.makeAnEpicNFT()
	// wait for it to be minted
	await txn.wait()

	console.log("Minted NFT #1");
};

const runMain = async () => {	
	try {
		await main();
		process.exit(0);

	} catch (error) {
		console.log(error);
		process.exit(1);
	}
};

runMain();