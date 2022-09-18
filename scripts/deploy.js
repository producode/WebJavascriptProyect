const { ethers } = require("hardhat");

const deploy = async () => {
    const [deployer] = await ethers.getSigners();

    console.log("Deploying contract with the account:", deployer.address);

    const CertificadoIT = await ethers.getContractFactory("CertificadoIT")
    const deployed = await CertificadoIT.deploy();

    console.log("CertificadoIT is deployed at: ", deployed.address)
};
deploy().then(() => process.exit(0)).catch((error) => {
    console.log(error);
    process.exit(1);
});
