//SPDX-License-Identifier: MIT
//@FernandoArielRodriguez
pragma solidity >=0.4.4 <0.7.0;
pragma experimental ABIEncoderV2;
import "./SafeMath.sol";


interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transferFerPark(address client, address receiver,uint ammount) external returns(bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract FerParkToken is IERC20{

    string public constant name = "FerPark";
    string public constant symbol = "FPK";
    uint8 public constant decimals = 2;

    event Transfer(address indexed from, address indexed to, uint256 tokens);
    event Approval(address indexed owner, address indexed spender, uint256 tokens);


    using SafeMath for uint256;

    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;

    constructor (uint256 initialSupply) public{
        totalSupply_ = initialSupply;
        balances[msg.sender] = totalSupply_;
    }

// using library safeMath
    using SafeMath for uint256;

    // function implementations
    function totalSupply() public override view returns(uint){
        return totalSupply_;
    }

    function increaseTotalSupply(uint newTokensAmmount) public {
        totalSupply_ += newTokensAmmount;
        balances[msg.sender] += newTokensAmmount;
    }

    function balanceOf(address tokenOwner) public override view returns(uint){
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns(uint) {
        return allowed[owner][delegate];
    }

    
    function transfer(address recipient, uint ammount) public override returns(bool){
        
        require(ammount <= balances[msg.sender], "You dont have enough token balance");
        balances[msg.sender] = balances[msg.sender].sub(ammount);
        balances[recipient] = balances[recipient].add(ammount);
        emit Transfer(msg.sender, recipient, ammount);
        return true;
    }

    function transferFerPark(address client, address receiver,uint ammount) public override returns(bool){
        require(ammount <= balances[client], "You dont have enough token balance");
        balances[client] = balances[client].sub(ammount);
        balances[receiver] = balances[receiver].add(ammount);
        emit Transfer(msg.sender, receiver, ammount);
        return true;
    }

    function approve(address delegate, uint ammount) public override returns(bool){
        require(ammount <= balances[msg.sender], "Dont have enough quantity allowed by the owner");
        allowed[msg.sender][delegate].add(ammount);
        emit Approval(msg.sender, delegate, ammount);
        return true;
    }

    function transferFrom(address owner, address buyer, uint ammount) public override returns(bool){
        require(ammount <= balances[owner], "You dont have enough tokens");
        require(ammount <= allowed[owner][msg.sender], "Dont have enough quantity allowed by the owner");
        balances[owner] = balances[owner].sub(ammount);
        allowed[owner][msg.sender] = allowed[owner][msg.sender].sub(ammount);
        balances[buyer] = balances[buyer].add(ammount);
        emit Transfer(owner, buyer, ammount);
        return true;
    }
}