pragma solidity ^0.4.11;


contract DLottery {

    // current lotto info
    address[] private empty;
    address[] private owners;
    uint private lotteryEndTime;
    uint private duration;
    bool private ended; // what would I need an ended for?  guessing i'm gonna need it

    // last lotto
    address private lastWinner; // winner, pot_size, duration
    uint private lastPot;
    uint private lastDuration;

    uint public test;

    // Contract constructor, called when the contract is deployed
    // When launched, make auctions one day long
    function DLottery() public {
        test = 0;
        lastWinner = 1;
        lastPot = 1;
        lastDuration = 1;
        commenceLottery(10); // 86400 seconds in one day
    }

    /*
      Interface Functions:
    */
    function getLastWinner() public returns (address) {
        return lastWinner;
    }

    function getLastPot() public returns (uint) {
        return lastPot;
    }

    function getLastDuration() public returns (uint) {
        return lastDuration;
    }

    function getLottoData() public returns (uint[3]) {
        // return data about this lotto
        return [duration, lotteryEndTime, owners.length];
    }

    // 1 ticket = 1 wei
    function buyTickets(uint tickets) public payable returns (uint) {

        //uint tickets = msg.value; // get wei sent

        // append users address tickets times
        for (uint i = 0; i < tickets; i++) {
            owners.push(msg.sender);
        }
        return owners.length;
    }

    // Called by dapp to check if the auction is over, and
    //  triggers closeLottery if so
    function getTimeRemaining() public returns (uint) {
        if (now >= lotteryEndTime) {
            test = 2;
            closeLottery();
            test = 3;
        }
        test = 4;
        return lotteryEndTime - now;
    }

    // Todo //
    // Called when the lottery end event detected
    function closeLottery() private {
        // choose winner
        uint windex = uint(block.blockhash(block.number-1)) % owners.length; // PICK RANDOM WINNER TODO
        address winner = owners[windex];
        winner.transfer(owners.length); // send ether to the winner

        // update info because lotto closed
        lastWinner = winner;
        lastPot = owners.length;
        lastDuration = duration;

        // start new lotto
        commenceLottery(duration);
    }

    // Start lottery in constructor and when each lottery ends
    function commenceLottery(uint durationSeconds) private {
        // reset params
        duration = durationSeconds;
        lotteryEndTime = now + durationSeconds; // set endtime to now + time
        owners = empty; // reset owners
    }
}
