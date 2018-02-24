pragma solidity ^0.4.11;


contract DLottery {

    // current lotto info
    address[] private empty;
    address[] public owners;
    uint private lotteryEndBlock;
    uint private duration;

    // last lotto
    address private lastWinner; // winner, pot_size, duration
    uint private lastPot;
    uint private lastDuration;
    uint private lastEndBlock;
    uint private allTimeBets;

    uint public test;

    // Contract constructor, called when the contract is deployed
    // When launched, make auctions one day long
    function DLottery() public {
        allTimeBets = 100;
        test = 0;
        lastWinner = 1;
        lastPot = 1;
        lastDuration = 10;
        commenceLottery(10); // 86400 seconds in one day
    }

    // fallback function for when ether received
    function () payable {
        for (uint i = 0; i < msg.value; i++) {
            owners.push(msg.sender);
            allTimeBets += 1;
        }
    }

    /*
      Interface Functions:
    */
    // 1 ticket = 1 wei
    function buyTickets(uint tickets) public payable returns (uint) {
        assert(tickets == msg.value);
        checkClosed();
        //uint tickets = msg.value; // get wei sent

        // append users address tickets times
        for (uint i = 0; i < tickets; i++) {
            owners.push(msg.sender);
            allTimeBets += 1;
        }
        return owners.length;
    }

    function getPotSize() public returns (uint) {
        return owners.length;
    }

    // Called by dapp to check if the auction is over, and
    //  triggers closeLottery if so
    function getBlocksRemaining() public returns (uint) {
        return lotteryEndBlock - block.number;
    }

    // returns duration of this auction in blocks
    function getDuration() public returns (uint) {
        return duration;
    }

    function getLastWinner() public returns (address) {
        return lastWinner;
    }

    function getLastPot() public returns (uint) {
        return lastPot;
    }

    function getLastDuration() public returns (uint) {
        return lastDuration;
    }

    function getLastEndBlock() public returns (uint) {
        return lastEndBlock;
    }

    function getAllTimeBets() public returns (uint) {
        return allTimeBets;
    }

    // Called when the lottery end event detected
    function closeLottery() private {

        // if participants, get winner and send winnings
        if (owners.length > 0) {
            uint windex = uint(block.blockhash(block.number-1)) % owners.length;
            address winner = owners[windex];
            winner.send(lastPot); // send ether to winner
        }

        // update info because lotto closed
        lastWinner = winner;
        lastPot = owners.length;
        lastDuration = duration;
        lastEndBlock = block.number;

        // start new lotto
        commenceLottery(duration);
    }

    function checkClosed() private {
        if (block.number >= lotteryEndBlock) {
            closeLottery();
        }
    }

    // Start lottery in constructor and when each lottery ends
    function commenceLottery(uint durationBlocks) private {
        // reset params
        duration = durationBlocks;
        lotteryEndBlock = block.number + duration;
        owners = empty; // reset owners
    }
}
