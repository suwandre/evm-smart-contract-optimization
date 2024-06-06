// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

contract ContractMV3 {
    struct Loan {
        uint256 id;
        // principal in wei
        uint256 principal;
        // assuming rate is the equivalent amount in integer form (e.g. 5% is 5)
        uint256 rate;
        // time in years
        uint256 time;
    }

    mapping(uint256 => Loan) public loans;

    function setLoan(uint256 id, uint256 principal, uint256 rate, uint256 time) public {
        loans[id] = Loan(id, principal, rate, time);
    }

    // function to calculate total accrued interest for all loans
    function calculateTotalInterest() public view returns (uint256 totalInterest) {
        uint256 total = 0;
        // just assuming that there are 100 loans for simplicity
        for (uint256 i = 0; i < 100; i++) {
            if (loans[i].principal > 0) {
                uint256 amount = loans[i].principal;
                for (uint256 j = 0; j < loans[i].time; j++) {
                    amount += amount * loans[i].rate / 100;
                }
                total += amount - loans[i].principal;
            }
        }
        return total;
    }
}