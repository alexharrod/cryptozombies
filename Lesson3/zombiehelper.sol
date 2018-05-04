pragma solidity ^0.4.19;

import "./zombiefeeding.sol";

//contract that inheris zombie feeding and thus zombie factory
contract ZombieHelper is ZombieFeeding {

	//modifier allows us to restrict certain functions to only zombies at a certain level
  	modifier aboveLevel(uint _level, uint _zombieId) {
    		require(zombies[_zombieId].level >= _level);
    		_;
  	}

	//function to change zombies name, must be level 2 at least
  	function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId) {
   		require(msg.sender == zombieToOwner[_zombieId]);
    	//update name
		  zombies[_zombieId].name = _newName;
  	}

	//function to change dna, must be at least level 20
  	function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId) {
    	//verify owner
		  require(msg.sender == zombieToOwner[_zombieId]);
    	zombies[_zombieId].dna = _newDna;
  	}

	//show all the zombies owned by an owner
  	function getZombiesByOwner(address _owner) external view returns(uint[]) {
    	uint[] memory result = new uint[](ownerZombieCount[_owner]);
    	uint counter = 0;
    	//sequence through all zombies owners
		  for (uint i = 0; i < zombies.length; i++) {
      //if our zombie owner add to array
			  if (zombieToOwner[i] == _owner) {
          result[counter] = i;
        	counter++;
      		}
    		}
    		return result;
  	}

}
