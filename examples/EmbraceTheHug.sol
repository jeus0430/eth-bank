pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract EmbraceNFT is ERC721PresetMinterPauserAutoId, Ownable {
    string public baseURIValue;

    constructor()
    ERC721PresetMinterPauserAutoId(
        "Embrace The Hug",
        "ETHUG",
        "? can set initial baseUri here?"
    )
    {}

    // NOTE:  Not sure what this function is for
    function _baseURI() internal view override returns (string memory) {
        return baseURIValue;
    }

    //I guess it's good to have a getter in case we want to check it ???
    function getBaseURI() public view returns (string memory) {
        return _baseURI();
    }

    //IMPORTANT: we want to be able to update this in case we need to update Metadata!
    function setBaseURI(string memory newBase) public onlyOwner {
        baseURIValue = newBase;
    }
}
