//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract WageContract {
    address payable public owner;
    error Error__TransactionFailed();

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    struct s_employee {
        uint256 intervalWage;
        uint256 intervalTime;
        bool active;
        uint256 claimable;
        uint256 lastClaimed;
        uint256 totalClaimed;
    }
    address payable[] employeeList;
    mapping(address => s_employee) public employee;

    receive() external payable {}

    function createPaymentPlan(
        address payable _employeeAddress,
        uint256 _intervalWage,
        uint256 _intervalTime
    ) external onlyOwner {
        require(_employeeAddress != address(0));
        employee[_employeeAddress].intervalWage = _intervalWage;
        employee[_employeeAddress].intervalTime = _intervalTime;
        employee[_employeeAddress].active = true;
        employee[_employeeAddress].lastClaimed = block.timestamp;
        employeeList.push(_employeeAddress);
    }

    function claimWages() external {
        require(
            employee[msg.sender].active == true,
            "Payment suspended by the owner"
        );

        uint256 timeElapsed = block.timestamp -
            employee[msg.sender].lastClaimed;
        uint256 timeInterval = employee[msg.sender].intervalTime;
        employee[msg.sender].claimable =
            ((timeElapsed - (timeElapsed % timeInterval)) / timeInterval) *
            employee[msg.sender].intervalWage;
        require(
            employee[msg.sender].claimable > 0,
            "Nothing to claim, check balance with myPaymentPlan()."
        );

        employee[msg.sender].lastClaimed =
            block.timestamp -
            (timeElapsed % timeInterval);
        employee[msg.sender].claimable = 0;
        employee[msg.sender].totalClaimed += employee[msg.sender].claimable;
        bool success = payable(msg.sender).send(employee[msg.sender].claimable);

        if (!success) {
            revert Error__TransactionFailed();
        }
    }

    function myPaymentPlan()
        external
        view
        returns (
            uint256 moneyPerInterval,
            uint256 timeInterval,
            bool paymentOngoing,
            uint256 lastClaimed,
            uint256 claimableAmount,
            uint256 totalClaimed
        )
    {
        return (
            employee[msg.sender].intervalWage,
            employee[msg.sender].intervalTime,
            employee[msg.sender].active,
            employee[msg.sender].lastClaimed,
            calculateWage(msg.sender),
            employee[msg.sender].totalClaimed
        );
    }

    function checkContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function pausePayment(address payable _employee) external onlyOwner {
        bool success = _employee.send(calculateWage(_employee));
        require(success);
        employee[_employee].active = false;
        employee[_employee].intervalTime = 2 * 10**25;
    }

    function unpausePayment(address _employee, uint256 _intervalTime)
        external
        onlyOwner
    {
        employee[_employee].active = true;
        employee[_employee].intervalTime = _intervalTime;
    }

    function calculateWage(address _address) private view returns (uint256) {
        uint256 timeElapsed = block.timestamp - employee[_address].lastClaimed;
        uint256 timeInterval = employee[_address].intervalTime;
        return
            ((timeElapsed - (timeElapsed % timeInterval)) / timeInterval) *
            employee[_address].intervalWage;
    }

    function selfDestruct() external onlyOwner {
        for (uint256 i = 0; i < employeeList.length; i++) {
            address payable employeeAddress = employeeList[i];
            if (calculateWage(employeeAddress) > 0) {
                employeeAddress.transfer(calculateWage(employeeAddress));
            }
        }

        selfdestruct(owner);
    }
}
