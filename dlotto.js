if (typeof web3 !== 'undefined') {
    web3 = new Web3(web3.currentProvider);
} else {
    // set the provider you want from Web3.providers
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
}
abi = JSON.parse(''); // forgot where I get the ABI
DLottoContract = web3.eth.contract(abi);
contractAddress = '0xe5214a07916d27a691d8be6e48847169c41a160e';
contractInstance = DLottoContract.at(contractAddress);
userAddress = '';


// test to see if compiled
lastWinner.innerText = "TEST";


// update with current information
timeLeft.innerText = contractInstance.methods.getTimeRemaining().call(); // need to call first since updates everything else if closed
potSize.innerText = contractInstance.methods.getPotSize().call();
duration.innerText = contractInstance.methods.getDuration().call();

lastWinner.innerText = contractInstance.methods.getLastWinner().call();
lastPot.innerText = contractInstance.methods.getLastPot().call();
ended.innerText = contractInstance.methods.getLastEndTime().call();
lastDuration.innerText = contractInstance.methods.getLastDuration().call();


// Need to hook up amount text box with the purchase command
function buyTickets() {
    // get textbox value
    amount = tickets.innerText;

    // then buy that much ether from the account
    var send = web3.eth.sendTransaction({from:eth.coinbase, to:contractAddress, value:web3.toWei(amount, "wei")});
}
