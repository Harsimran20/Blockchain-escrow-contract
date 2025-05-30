// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Escrow is ReentrancyGuard {
    enum Status { AWAITING_PAYMENT, PAID, DELIVERED, DISPUTED, COMPLETE, CANCELLED }

    struct Order {
        address payable buyer;
        address payable seller;
        uint amount;
        uint deadline;
        Status status;
        address arbitrator;
    }

    uint public orderCount;
    mapping(uint => Order) public orders;

    event OrderCreated(uint orderId, address buyer, address seller, uint amount);
    event Delivered(uint orderId);
    event Disputed(uint orderId);
    event Resolved(uint orderId, address winner);
    event Completed(uint orderId);

    modifier onlyBuyer(uint id) {
        require(msg.sender == orders[id].buyer, "Not buyer");
        _;
    }

    modifier onlyArbitrator(uint id) {
        require(msg.sender == orders[id].arbitrator, "Not arbitrator");
        _;
    }

    function createOrder(address payable _seller, address _arbitrator) external payable returns (uint) {
        require(msg.value > 0, "No funds sent");

        orders[orderCount] = Order({
            buyer: payable(msg.sender),
            seller: _seller,
            amount: msg.value,
            deadline: block.timestamp + 7 days,
            status: Status.PAID,
            arbitrator: _arbitrator
        });

        emit OrderCreated(orderCount, msg.sender, _seller, msg.value);
        return orderCount++;
    }

    function markDelivered(uint orderId) external {
        Order storage o = orders[orderId];
        require(msg.sender == o.seller, "Not seller");
        require(o.status == Status.PAID, "Invalid status");

        o.status = Status.DELIVERED;
        emit Delivered(orderId);
    }

    function approveOrder(uint orderId) external onlyBuyer(orderId) nonReentrant {
        Order storage o = orders[orderId];
        require(o.status == Status.DELIVERED, "Delivery not confirmed");

        o.status = Status.COMPLETE;
        o.seller.transfer(o.amount);
        emit Completed(orderId);
    }

    function raiseDispute(uint orderId) external onlyBuyer(orderId) {
        Order storage o = orders[orderId];
        require(o.status == Status.DELIVERED, "Not delivered");
        o.status = Status.DISPUTED;
        emit Disputed(orderId);
    }

    function resolveDispute(uint orderId, bool refundBuyer) external onlyArbitrator(orderId) nonReentrant {
        Order storage o = orders[orderId];
        require(o.status == Status.DISPUTED, "Not in dispute");

        o.status = Status.COMPLETE;
        address payable winner = refundBuyer ? o.buyer : o.seller;
        winner.transfer(o.amount);

        emit Resolved(orderId, winner);
    }

    function cancelIfTimeout(uint orderId) external onlyBuyer(orderId) {
        Order storage o = orders[orderId];
        require(o.status == Status.PAID, "Not cancellable");
        require(block.timestamp > o.deadline, "Not expired");

        o.status = Status.CANCELLED;
        o.buyer.transfer(o.amount);
    }
}
