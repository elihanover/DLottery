pragma solidity 0.4.19;


contract DLottery {

    // current lotto info
    address[] public empty;
    address[] public owners;
    uint public lotteryEndTime;
    uint public duration;
    bool public ended; // what would I need an ended for?  guessing i'm gonna need it

    // last lotto
    address public lastWinner; // winner, pot_size, duration
    uint public lastPot;
    uint public lastDuration;

    /* Intra-Contract Functions */
    // Contract constructor, called when the contract is deployed
    // When launched, make auctions one day long
    function DLottery() public {
        commenceLottery(3); // 86400 seconds in one day
    }

    // Start lottery in constructor and when each lottery ends
    function commenceLottery(uint durationMinutes) public {
        // reset params
        duration = durationMinutes;
        lotteryEndTime = now + durationMinutes*60; // set endtime to now + time
        owners = empty; // reset owners
    }

    // Called by dapp to check if the auction is over, and
    //  triggers closeLottery if so
    function isOver() public {
        if (now >= lotteryEndTime) {
            closeLottery();
        }
    }

    // Todo //
    // Called when the lottery end event detected
    function closeLottery() public {
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
    function buyTickets() public payable {

        uint tickets = msg.value; // get wei sent

        // append users address tickets times
        for (uint i = 0; i < tickets; i++) {
            owners.push(msg.sender);
        }
    }
}
