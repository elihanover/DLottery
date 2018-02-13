pragma solidity 0.4.19;


contract DLottery {

    // do I want this public or private?
    // index = ticket number,
    // value = address
    address[] public owners;


    uint[3] public lastLottoInfo; // winner, pot_size, duration

    // lotto info
    uint public lotteryEndTime;
    uint public duration;
    uint public potSize;
    bool public ended;

    address winner public ;

    function DLottery() public {
        commenceLottery();
    }

    function commenceLottery(uint durationSeconds) public {
        // Start lottery in constructor and when each lottery ends
        duration = durationSeconds;
        lotteryEndTime = now + durationSeconds; // set endtime to now + time
        owners = address[]; // reset owners
    }

    function chooseWinner() public returns (address) {
        // pick random ticket and return the address who owns it
        uint windex = 1;// randint(0, ticketOwners.keys.size-1)
        winner = owners[windex];
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

        // set winner so that winner can claim reward
        chooseWinner();

        // don't want to just send ether because it could invoke an untrusted contract
        // instead you want to publish the winner and allow them to withdraw funds

    }

    function getWinner() public returns (address) {
        // called by dapp in order to publish winner
        if (winner != None) {
            // update lastlottoinfo with closed lotto info
            lastLottoInfo = [winner, pot_size, duration];

            // reset params
            winner = None;
            pot_size = 0;
            duration = duration; // update with voting later

            return winner;
        }
    }

    function getLastLottoData() public returns (uint[3]) {
        // winner, amount, duration
        return lastLottoInfo;
    }

    function getLottoData() public returns (uint[3]) {
        // return data about this lotto
        return [duration, lotteryEndTime, potSize];
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
