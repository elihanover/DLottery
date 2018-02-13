pragma solidity 0.4.19;


contract DLottery {

    // do I want this public or private?
    // index = ticket number,
    // value = address
    address[] public owners;
    uint public lotteryEndTime;
    bool public ended;

    function DLottery() {
        commenceLottery();
    }

    function commenceLottery(uint durationSeconds) public {
        // Start lottery in constructor and when each lottery ends
        lotteryEndTime = now + durationSeconds; // set endtime to now + time
        owners = address[]; // reset owners
    }

    function chooseWinner() public returns (address) {
        // pick random ticket and return the address who owns it
        uint winner = 1;// randint(0, ticketOwners.keys.size-1)
        return owners[winner];
    }

    // 1 ticket = 1 wei
    function buyTickets() public payable {

        require(now < lotteryEndTime);

        uint tickets = msg.value; // get wei sent

        // append users address tickets times
        for (uint i = 0; i < tickets; i++) {
            owners.push(msg.sender);
        }
    }

    function closeLottery() public {
        // conditions
        require(now >= lotteryEndTime); // ensure no early call
        require(!ended); // make sure not already called

        ended = true;

        address winner = chooseWinner();

        // don't want to just send ether because it could invoke an untrusted contract
        // instead you want to publish the winner and allow them to withdraw funds
        
    }


    /*
      Questions:
        - How do when know when to release funds?
        - How do we randomly select winner?

      Todo:
        - User voting on lottery params
    */

}
