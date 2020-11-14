pragma solidity ^0.6.0;

import './EcoToken.sol';

contract EcoExchange {

    string public marketplaceName;
    uint public productCount;
    EcoToken public tokenContract; 

    struct Product {
        uint productId;
        address productCreator;
        string productName;
        uint amount;
        uint tokenPrice;
    }

    struct Company {
        address company;
        string companyName;
    }

    struct Consumer {
        address consumer;
        string consumerName;
        uint points;
    }

    mapping(uint => Product) products;
    mapping(address => Company) companies;
    mapping(address => Consumer) consumers;
    //address[] consumers; 

    constructor(string memory _marketplaceName, address _tokenContract, address EcoTokenOwner) public {
        marketplaceName = _marketplaceName;
        tokenContract = EcoToken(_tokenContract);
        tokenContract.transferFrom(EcoTokenOwner, address(this), (tokenContract.balanceOf(EcoTokenOwner)));
        productCount = 0;
    }

    event ProductCreated(
        uint indexed productId,
        address indexed creator,
        string productName,
        uint amount,
        uint tokenPrice
    );

    event ProductPurchased(
        uint indexed productId,
        address indexed buyer,
        string productBuyer,
        string productName,
        uint amount
    );

    event ProductAmountUpdate(
        uint productId,
        string productName,
        uint amount
    );

    function addConsumer(address _consumer, string memory _consumerName) public returns(bool){
        consumers[_consumer] = Consumer(_consumer, _consumerName, 0);
        return true;
    }

    function addCompany(address _company, string memory _companyName) public returns(bool){
        companies[_company] = Company(_company, _companyName);
        return true;
    }

    function createProduct( 
        address _productCreator, 
        string memory _productName, 
        uint _amount, 
        uint _tokenPrice
    ) 
        public 
        returns(uint productId)
    {
        require(_amount > 0);
        require(_tokenPrice > 0);
        productId = productCount++;
        products[productId] = Product(productId, _productCreator, _productName, _amount, _tokenPrice);

        emit ProductCreated (productId, _productCreator, _productName, _amount, _tokenPrice);
    }

    function updateProductAmount(uint _productId, uint _amount) public returns(bool){
        Product storage p = products[_productId];
        p.amount = _amount;
        
        emit ProductAmountUpdate(p.productId, p.productName, p.amount);
        return true;
    }

    function getTokenForGoodDeeds(address _consumer) public returns(bool) {
        Consumer storage c = consumers[_consumer];
        require(c.points > 500);

        uint actualPionts = c.points;
        uint _tokenAmount = 0;

        while(c.points > 500) {
            _tokenAmount++;
            c.points -= 500;
        }

        c.points = actualPionts;

        if(!tokenContract.transfer(_consumer, _tokenAmount)){
            revert("transfer failed");
        }

        return true;
    }

    // Exchange Rate is 2 : 1 (Ether or an own currency : Token)
    function getTokenForEther(uint _tokenAmount) public payable returns(bool) {
        require(msg.value > _tokenAmount * 2);
        require(_tokenAmount > 0);
        require(tokenContract.balanceOf(address(this)) >= _tokenAmount);

        if(!tokenContract.transfer(msg.sender, _tokenAmount)){
            revert("transfer failed");
        }
        
        return true;
    }

    function exchangeTokenForProduct(uint _productId, address _consumer, uint _amount) public returns(bool) {
        Product storage p = products[_productId];
        Consumer storage c = consumers[_consumer];

        require(tokenContract.balanceOf(_consumer) >= p.tokenPrice);

        uint counter = _amount;
        while(counter > 0){
            if(!tokenContract.transfer(p.productCreator, p.tokenPrice)){
                revert("transfer failed");
            }
            p.amount--;
        }

        emit ProductPurchased(_productId, _consumer, c.consumerName, p.productName, _amount);

    }

    //modifier consumerExists

    //modifier companyExists

    //modifier productExists
}