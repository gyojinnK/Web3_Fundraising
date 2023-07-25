pragma solidity ^0.8.0;

// [ property ]
// owner : 프로젝트 소유자
// target Amount : 모으려는 돈의 총 금액
// list of people that donated : 프로젝트에 기부한 모든 사람들의 리스트
// donations : 기부금
// Accumulated Total : 기부금의 누적 총액
// deadline : 목표액 도달까지, 프로젝트가 갖고있는 시간

contract Fundraising{
    uint256 public targetAmount;
    address public owner;
    mapping(address => uint256) public donations;

    uint256 public raisedAmount = 0;
    uint256 public finishTime = block.timestamp + 2 weeks;  
    // block : 컨트랙트를 배포할 때, EVM에 의해 정의될 객체 | block.timestamp는 블록이 생성되는 날짜를 초로 기록
}