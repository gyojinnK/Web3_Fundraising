pragma solidity ^0.8.0;

// [ property ]
// owner: 프로젝트 소유자
// target Amount: 모으려는 돈의 총 금액
// list of people that donated: 프로젝트에 기부한 모든 사람들의 리스트
// donations: 기부금
// Accumulated Total: 기부금의 누적 총액
// deadline: 목표액 도달까지, 프로젝트가 갖고있는 시간

contract Fundraising{
    uint256 public targetAmount;
    address public owner;
    mapping(address => uint256) public donations;

    uint256 public raisedAmount = 0;
    // block: 컨트랙트를 배포할 때, EVM에 의해 정의될 객체 | block.timestamp는 블록이 생성되는 날짜를 초로 기록
    uint256 public finishTime = block.timestamp + 2 weeks;  

    // 컨트랙트를 배포할 때 프로젝트 소유자가 모금하고자 하는 금액을 명시할 수 있도록 하겠다는 뜻
    constructor(uint256 _targetAmount) {
        targetAmount = _targetAmount;
        // 해당 컨트랙트를 작성하는 행위자의 주소
        owner = msg.sender; 
    }

    // 알아두기
    // EVM 블록체인에는 두 가지 유형의 계정이 존재
    // 1. EOA: 사람이 관리하는 외부 소유 계장
    // 2. 코드가 관리하는 컨트랙트 계정
    // + EOA 계정은 컨트랙트 계정으로 돈을 보낼 수 있음
    // + 컨트랙트 계정 또한 EOA 계정으로 돈을 보낼 수 있음
    // 모금한 돈을 확인하고 후원한 사람의 주소와 금액을 기록해야하기 때문에 컨트랙트 계좌로 돈을 보낼 수 있는 코드를 작성할 것임 + 환불 가능

    // external: 컨트랙트 외부에서만 호출 가능
    // payable: 이 함수가 돈을 받을 수 있다는 것을 명시하는 modifier
    //  + 누군가가 해당 컨트랙트로 돈을 보내면 receive함수가 실행됨
    receive() external payable{
        require(block.timestamp < finishTime, "This campaign is over.");
        // require문을 성공적으로 빠져 나왔다면
        // 돈을 보낸 사람의 주소와 금액을 추가
        //  + msg.sender를 이용하여 누가 해당 컨트랙트로 돈을 보내는지 알 수 있음.
        //  + msg.value: 보내진 금액
        donations[msg.sender] += msg.value;
        // 인상된 금액만큼 amount를 증가
        raisedAmount += msg.value;
    }

    // 이 함수를 호출하는 사람이 컨트랙트를 생성한 사람과 동일한지를 체크
    function withdrawDonations() external{
        require(msg.sender == owner, "Funds will only be released to the owner.");
        require(raisedAmount >= targetAmount, "The project did not reach the goal.");
        require(block.timestamp > finishTime, "The campaign is not over yet.");
        // 조건을 모두 만족했다면
        // constructor에 설정한 소유자의 주소로
        // payable function 호출
        // transfer: raisedAmount 변수의 값을 전송
        payable(owner).transfer(raisedAmount);
    }

    // 기부한 사람들에게 환불 해주는 함수
    function refund() external{
        require(block.timestamp > finishTime, "The campaign is not over yet.");
        require(raisedAmount < targetAmount, "This campaign reached the goal.");
        require(donations[msg.sender] > 0, "You did not donate to this campaign.");
        // 모든 조건이 참이라면 
        // 컨트랙트 사용자가 기부했던 만큼의 금액을 toRefund 변수에 저장
        uint256 toRefund = donations[msg.sender];
        donations[msg.sender] = 0;
        payable(msg.sender).transfer(toRefund);
    }
}