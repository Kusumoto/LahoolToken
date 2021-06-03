const hre = require("hardhat");

async function main() {
    const migration = await hre.ethers.getContractFactory("Migrations");
    const migrationContract = await migration.deploy();
    await migrationContract.deployed();

    const LahoolToken = await hre.ethers.getContractFactory("LAHOOL");
    const lahoolTokenContract = await LahoolToken.deploy();
    await lahoolTokenContract.deployed();

    console.log("Lahool Token deployed to:", lahoolTokenContract.address);
}

main()
    .then(() => process.exit(0))
    .catch(error => {
        console.error(error);
        process.exit(1);
    });
