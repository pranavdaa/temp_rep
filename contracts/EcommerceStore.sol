pragma solidity ^0.5.0; //change

import "./Escrow.sol";

contract EcommerceStore {

    enum ProductCondition {New, Used}

    uint public productIndex;

    address public arbiter;

    mapping (address => mapping(uint => Product)) stores;
    mapping (uint => address payable) productIdInStore; //change

    mapping (uint => address ) productEscrow;
    struct Product {
        uint id;
        string name;
        string category;
        string imageLink;
        string descLink;
        uint startTime;
        uint price;
        ProductCondition condition;
        address buyer;
    }

    event NewProduct(uint _productId, string _name, string _category, string _imageLink,
                    string _descLink, uint _startTime, uint _price, uint _productCondition);

    constructor(address _arbiter) public {
        productIndex = 0;
        arbiter = _arbiter;
    }

    function addProductToStore(string memory _name, string memory _category, string memory _imageLink,
        string memory _descLink, uint _startTime, uint _price, uint _productCondition) public {
//chnage
        productIndex += 1;
        Product memory product = Product(productIndex, _name, _category, _imageLink,
            _descLink, _startTime, _price, ProductCondition(_productCondition),msg.sender); //change the left one 0 ->msg.sender
        stores[msg.sender][productIndex] = product;
        productIdInStore[productIndex] = msg.sender;
        emit NewProduct(productIndex, _name, _category, _imageLink, _descLink, _startTime,
                       _price, _productCondition);
    }

    function getProduct(uint _productId) public view returns (uint, string memory, string memory, string memory,
        string memory, uint, uint, ProductCondition, address) { //chnage

        Product memory product = stores[productIdInStore[_productId]][_productId]; //change
        return (product.id, product.name, product.category, product.imageLink,
            product.descLink, product.startTime, product.price,
            product.condition, product.buyer);
    }

    function buy(uint _productId) payable public {  //change
        Product memory product = stores[productIdInStore[_productId]][_productId]; //chnage
        require(product.buyer == address(0));
        require(msg.value >= product.price);
        product.buyer = msg.sender;
        stores[productIdInStore[_productId]][_productId] = product;
        Escrow escrow = (new Escrow).value(msg.value)(_productId, msg.sender, productIdInStore[_productId], arbiter);

        productEscrow[_productId] = address(escrow); //chnage explicite conversion of type
    }

    function escrowInfo(uint _productId) view public returns (address, address, address, bool, uint, uint) {
      return Escrow(productEscrow[_productId]).escrowInfo();
    }

    function releaseAmountToSeller(uint _productId) public {
      Escrow(productEscrow[_productId]).releaseAmountToSeller(msg.sender);
    }

    function refundAmountToBuyer(uint _productId) public {
      Escrow(productEscrow[_productId]).refundAmountToBuyer(msg.sender);
    }
}
