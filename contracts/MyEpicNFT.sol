// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0; //sets the version of soliditiy to use.

// importing util function for strings
import "@openzeppelin/contracts/utils/Strings.sol";
// importing openzeppelin contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "hardhat/console.sol";

// We need to import the helper functions from the contract that we copy/pasted.
import { Base64 } from "./libraries/Base64.sol";

// once we intialize the contract for first time , the constructor will run 
// and print for the first time.

contract MyEpicNFT is ERC721URIStorage{

	// to keep track of tokenIds , feature of openzeppelin
	using Counters for Counters.Counter;
	Counters.Counter private _tokenIds;
	//tokenIds is a state variable , if we change it then change is directly stored on chain.

	string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

	string[] firstWords = ["A", "B", "C", "D", "E", "F"];
	string[] secondWords = ["1", "2", "3", "4", "5", "6"];
	string[] thirdWords = ["!", "@", "#", "$", "%", "^"];
	event NewEpicNFTMinted(address sender, uint256 tokenId);

	// passing name of nft's token and it's symbol
	constructor() ERC721 ("SquareNFT" , "SQUARE") {
		console.log("This is my first NFT contract , Woah !!");
	}

	function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
	uint rand = random(string(abi.encodePacked("FIRST_WORD" , Strings.toString(tokenId))));

	rand = rand % firstWords.length;
	return firstWords[rand];
	} 

		function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
	uint rand = random(string(abi.encodePacked("SECOND_WORD" , Strings.toString(tokenId))));

	rand = rand % secondWords.length;
	return secondWords[rand];
	} 

		function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
	uint rand = random(string(abi.encodePacked("THIRD_WORD" , Strings.toString(tokenId))));

	rand = rand % thirdWords.length;
	return thirdWords[rand];
	} 

	

	function random(string memory input) internal pure returns (uint256) {
	 return uint256(keccak256(abi.encodePacked(input)));
	}

	// a function our user will hit to get their nft
	function makeAnEpicNFT() public {

	// get current tokenId , starts at 0
	uint256 newItemId = _tokenIds.current();

	
	// picking up random words
	string memory first = pickRandomFirstWord(newItemId);
	string memory second = pickRandomSecondWord(newItemId);
	string memory third = pickRandomThirdWord(newItemId);
	string memory combinedWord = string(abi.encodePacked(first ,second , third));

	//concatenate all the things in one and end with text/svg.
	string memory finalSvg = string(abi.encodePacked(baseSvg, first, second, third, "</text></svg>"));

	string memory json = Base64.encode(
		bytes(
			string(
			abi.encodePacked(
			'{"name":"' , combinedWord , '","description" : "A highly acclaimed collection of squares." , "image" : "data:image/svg+xml;base64,' , Base64.encode(bytes(finalSvg)), '"}'

			)
			)
		)
	);

	string memory finalTokenUri = string(abi.encodePacked("data:application/json;base64," , json));

    console.log("\n--------------------");
    console.log(finalTokenUri);
    console.log("--------------------\n");

	// actually mint the nft to the sender 
	// msg.sender gives us the public address of the person calling the contract.
	// this mints the nft with newItemId to the user
	_safeMint(msg.sender , newItemId);

	// set the nft's data
	// the data that makes the nft actually valuable
	_setTokenURI(newItemId , finalTokenUri);

	console.log("An NFT w/ ID %s has been minted to %s" , newItemId , msg.sender);

	_tokenIds.increment();

	emit NewEpicNFTMinted(msg.sender, newItemId);
	}
}

