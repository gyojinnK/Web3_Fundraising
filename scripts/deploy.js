async function main() {
    // 자바스크립트 라이브러리인 ethers를 사용하여
    // Fundraising 컨트랙트를 가져와서 컴파일
    const Fundraising = await ethers.getContractFactory("Fundraising");
    // 한 개의 argument와 함께 디플로이 함
    // 이것이 해당 컨트랙트의 constructor가 필요한 argument임
    // 해당 캠페인의 목표 금액 이기도 함, 단위는 wei
    // 100 ether = 100000000000000000000 wei
    const contract = await Fundraising.deploy(10000000000);
    //
    console.log("Contract address is: ", contract.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
