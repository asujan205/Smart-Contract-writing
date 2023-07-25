
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract Events {


    event NewPerson(
        uint id,
        string name,
        uint age,
        uint height,
        bool senior
    );

    uint public peopleCount = 0;

    struct Person {
        uint id;
        string name;
        uint age;
        uint height;
        bool senior;
    }

    mapping(address => Person) private people;


    function createPerson(string memory name, uint age, uint height) public {
        require(age < 150, "Age needs to be below 150");
        require(bytes(name).length > 0, "Name needs to be valid");
        require(height > 0, "Height needs to be above 0");
        peopleCount++;
        people[msg.sender] = Person(peopleCount, name, age, height, age >= 65);
        emit NewPerson(peopleCount, name, age, height, age >= 65);
    }






}
