pragma solidity 0.4.19;


contract DLottery {

    // current lotto info
    address[] public owners;
    uint public lotteryEndTime;
    uint public duration;
    bool public ended;
    address public winner;

    // last lotto
    uint[3] public lastLottoInfo; // winner, pot_size, duration

    /*
      Intra-Contract Functions
    */
    // Contract constructor, called when the contract is deployed
    // When launched, make auctions one day long
    function DLottery() public {
        commenceLottery(86400); // 86400 seconds in one day
    }

    // Start lottery in constructor and when each lottery ends
    function commenceLottery(uint durationMinutes) public {
        // reset params
        winner = ; // reset winner to what?
        duration = durationMinutes;
        lotteryEndTime = now + durationMinutes*60; // set endtime to now + time
        owners = address[]; // reset owners
    }

    // Todo //
    // Called when the lottery end event detected
    function closeLottery() public {
        // conditions
        require(now >= lotteryEndTime); // ensure no early call
        require(!ended); // make sure not already called

        ended = true;

        // choose winner
        uint windex = randint(0, owners.length-1); // PICK RANDOM WINNER TODO
        winner = owners[windex];
        winner.transfer(owners.length); // send ether to the winner

        // update info because lotto closed
        lastLottoInfo = [winner, owners.length, duration];

        // start new lotto
        commenceLottery(duration);
    }

    /*
      Interface Functions:
    */
    function getLastLottoData() public returns (uint[3]) {
        // winner, amount, duration
        return lastLottoInfo;
    }

    function getLottoData() public returns (uint[3]) {
        // return data about this lotto
        return [duration, lotteryEndTime, owners.length];
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


    /*
      Questions:
        - How do when know when to release funds?
        - How do we randomly select winner?
        - How to best unlock winner's winnings?

      Todo:
        - User voting on lottery params
    */

}
