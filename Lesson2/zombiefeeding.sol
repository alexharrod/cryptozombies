pragma solidity ^0.4.19;

//import zombiefactory contract
import "./zombiefactory.sol";

//Create interface with cryptokitty
contract KittyInterface {
  function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
  );
}

//new contract for feeding
contract ZombieFeeding is ZombieFactory {
  
  // call in the cryptokitty address
  address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
  KittyInterface kittyContract = KittyInterface(ckAddress);

  //function to create new dna after feeding
  function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
    //make sure the user owns the zombie    
    require(msg.sender == zombieToOwner[_zombieId]);
    //declare local zombie and set the value to be our zombie id
    Zombie storage myZombie = zombies[_zombieId];
    _targetDna = _targetDna % dnaModulus;
    uint newDna = (myZombie.dna + _targetDna) / 2;
    //if feeding on cryptokitty then last 2 digits will be 99 to identify the species
    if (keccak256(_species) == keccak256("kitty")) {

      newDna = newDna - newDna % 100 + 99;
    
    }
    _createZombie("NoName", newDna);
  }

  function feedOnKitty(uint _zombieId, uint _kittyId) public {
    uint kittyDna;
    (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
    feedAndMultiply(_zombieId, kittyDna, "kitty");
  }

}
