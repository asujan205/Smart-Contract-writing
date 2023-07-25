// SPDX-License-Identifier: MIT

pragma solidity ^0.8.17;


contract MyStruct {


    struct Person {
        string name;
        uint age;
        uint height;
        bool senior;
    }

    Person[] public people;

    function createPerson(string memory name, uint age, uint height) public {
        Person memory newPerson;
        newPerson.name = name;
        newPerson.age = age;
        newPerson.height = height;
        if(age >= 65){
            newPerson.senior = true;
        }
        else{
            newPerson.senior = false;
        }
        people.push(newPerson);
    }


}