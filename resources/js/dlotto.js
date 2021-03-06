// get network
console.log(web3)

/* Contract Parameters */
abi = JSON.parse('[{"constant":true,"inputs":[],"name":"getPotSize","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[{"name":"","type":"uint256"}],"name":"owners","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getLastPot","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getLastDuration","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getAllTimeBets","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getBlocksRemaining","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getDuration","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getLastEndBlock","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"getLastWinner","outputs":[{"name":"","type":"address"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":true,"inputs":[],"name":"test","outputs":[{"name":"","type":"uint256"}],"payable":false,"stateMutability":"view","type":"function"},{"constant":false,"inputs":[],"name":"placeBet","outputs":[],"payable":true,"stateMutability":"payable","type":"function"},{"inputs":[],"payable":false,"stateMutability":"nonpayable","type":"constructor"}]');
DLottoContract = web3.eth.contract(abi);
contractAddress = '0x03348dd5ef4a94f27b17551c3beebaf9c559dcc6';
contractInstance = DLottoContract.at(contractAddress);
console.log(contractInstance);
userAddress = web3.eth.accounts[0]; // get account from provider
console.log("Balance: " + web3.eth.getBalance(userAddress))
// 99999999999984777058 balance
update();


function update() {
    // check if lottery closed
    //contractInstance.checkClosed.call();

    // update with current information
    document.getElementById("potSize").innerText = "PotSize: " + contractInstance.getPotSize.call().toString();
    document.getElementById("blocksLeft").innerText = "Blocks Left: " + contractInstance.getBlocksRemaining.call().toString(); // need to call first since updates everything else if closed
    document.getElementById("duration").innerText = "Duration (Blocks): " + contractInstance.getDuration.call().toString();

    document.getElementById("lastWinner").innerText = "Last Winner: " + contractInstance.getLastWinner.call().toString();
    document.getElementById("lastPot").innerText = "Last Pot Size: " + contractInstance.getLastPot.call().toString();
    document.getElementById("lastDuration").innerText = "Last Duration (Blocks): " + contractInstance.getLastDuration.call().toString();
    document.getElementById("lastEndBlock").innerText = "Last Ending Block: " + contractInstance.getLastEndBlock.call().toString();

    document.getElementById("allTimeBets").innerText = "All Time Bets: " + contractInstance.getAllTimeBets.call().toString();
}


// Need to hook up amount text box with the purchase command
function buyTickets() {
    // get textbox value
    amount = document.getElementById("tickets").value;
    console.log("amount: " + amount);

    // then buy that much ether from the account
    web3.personal.unlockAccount(userAddress, 'password')
    contractInstance.placeBet.sendTransaction({from: userAddress, value: amount, gas:6700000});
    console.log(contractInstance.getPotSize.call().toString());
    update();
}
