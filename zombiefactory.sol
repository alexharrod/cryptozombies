pragma solidity ^0.4.19;

//create new contract called ZombieFactory
contract ZombieFactory {
	

    //create an event when creating a new zombie for our web based app to listen out for
    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    //create a new struct called Zombie
    struct Zombie {
        string name;
        uint dna;
    }

    //create an array called zombies
    Zombie[] public zombies;

    //define mappings to identify zombie owner and count the number of zombies owned
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

    //function to add a new zombie to our zombies array
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        //define zombie owner
        zombieToOwner[id] = msg.sender;
        //increment the zombies owned by the owner by 1
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    }

    //function to generate a random number
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    //function to use the random number to create a new zombie and then trigger the _createZombie funtion to add it to the array
    function createRandomZombie(string _name) public {
        //user must not already own a zombie
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }

}
