pragma solidity ^0.4.19;

//https://ethereum.stackexchange.com/questions/28641/simplest-way-to-use-a-variable-in-an-oraclize-query?rq=1

contract Ethrow{
    
    address public owner;
    
    mapping(uint => address) public buddies;
    mapping(uint => address) public charities;
    mapping(uint => uint) public amounts;
    mapping(uint => address) public owners;
    mapping(uint  => uint) public times;
    mapping(address => uint[]) public escrowIDs;
    mapping(address => uint) balance;
    uint private nonce;
    
    event GoalClosed(string _s,address _a,uint _u);
    function deposit(uint _amount,address _charity, address _buddy, uint _daystilexp) payable public{
        require(_amount *1e18 == msg.value);
        escrowIDs[msg.sender].push(nonce);
        charities[nonce] = _charity;
        buddies[nonce] = _buddy;
        amounts[nonce] = _amount*1e18;
        owners[nonce] = msg.sender;
        times[nonce] = now + _daystilexp*86400;
        nonce++;
    }
    
    function disperse(uint _id, bool _goalmet) public{
        require(msg.sender == buddies[_id] && times[_id] > now);
        address _topay;
        if(_goalmet){
            _topay = owners[_id];
        }
      else{
            _topay = charities[_id];
        }
        _topay.transfer(amounts[_id]);
        GoalClosed("This goal is closed",_topay,amounts[_id]);
    }
    
}

//1,"0x14723a09acff6d2a60dcdf7aa4aff308fddc160c","0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db"
