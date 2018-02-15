pragma solidity ^0.4.11;


contract DLottery {

    // current lotto info
    address[] private empty;
    address[] private owners;
    uint private lotteryEndBlock;
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
        commenceLottery(1); // 86400 seconds in one day
    }

    /*
      Interface Functions:
    */
    function getLastWinner() public returns (address) {
        checkClosed();
        return lastWinner;
    }

    function getLastPot() public returns (uint) {
        checkClosed();
        return lastPot;
    }

    function getLastDuration() public returns (uint) {
        checkClosed();
        return lastDuration;
    }

    function getLottoData() public returns (uint[3]) {
        checkClosed();
        // return data about this lotto
        return [duration, lotteryEndBlock, owners.length];
    }

    // Called by dapp to check if the auction is over, and
    //  triggers closeLottery if so
    function getBlocksRemaining() public returns (uint) {
        checkClosed();
        return lotteryEndBlock - block.number;
    }

    // 1 ticket = 1 wei
    function buyTickets(uint tickets) public payable returns (uint) {
        checkClosed();
        //uint tickets = msg.value; // get wei sent

        // append users address tickets times
        for (uint i = 0; i < tickets; i++) {
            owners.push(msg.sender);
        }
        return owners.length;
    }

    // Called when the lottery end event detected
    function closeLottery() public {

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

        // start new lotto
        commenceLottery(duration);
    }

    function checkClosed() private {
        test = 3;
        if (block.number >= lotteryEndBlock) {
            //closeLottery();
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
