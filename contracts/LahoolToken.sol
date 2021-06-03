//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract LAHOOL is ERC20 {
    uint public constant _totalSupply = 1000000000000 * 10 ** 18;

    event Deposit(address indexed dst, uint256 value);
    event Withdrawal(address indexed src, uint256 value);
    event Paused(address account);
    event Unpaused(address account);

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    mapping (address => bool) public blacklist;
    
    bool public paused;

    constructor() ERC20('Lahool Token', 'LAHOOL') {
        _mint(msg.sender, 1000000 * 10 ** 18);
    }


    modifier whenNotPaused() {
        require(!paused, "Pausable: paused");
        _;
    }

    modifier whenPaused() {
        require(paused, "Pausable: not paused");
        _;
    }
  
    fallback() external payable {
        deposit();
    }
    
    receive() external payable {
        deposit();
    }

    function deposit() public whenNotPaused payable {
        balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
        emit Transfer(address(0), msg.sender, msg.value);
    }
    
    function withdraw(uint256 _value) public whenNotPaused  {
        _withdraw(_value, msg.sender);
    }
    
    function _withdraw(uint256 _value, address _addr) internal {
        require(balances[_addr] >= _value);
        balances[_addr] -= _value;
        payable(_addr).transfer(_value);
        emit Withdrawal(_addr, _value);
        emit Transfer(_addr, address(0), _value);
    }
    
    function totalSupply() public pure override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _addr) public view override returns (uint256) {
        return balances[_addr];
    }

    function allowance(address _owner, address _spender) public view override returns (uint256) {
        return allowed[_owner][_spender];
    }

    function approve(address _spender, uint256 _value) public override whenNotPaused returns (bool) {
        _approve(msg.sender, _spender, _value);
        return true;
    }
    
    function transfer(address _to, uint256 _value) public override whenNotPaused returns (bool) {
        require(_value <= balances[msg.sender], "Insufficient Balance");

        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);

        return true;
    }
}
