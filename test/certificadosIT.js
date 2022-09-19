const { expect } = require("chai");
const { ethers } = require("hardhat");
const { describe, it } = require("node:test");

describe('Contrato de certificado', () => {
    const setup = async () => {
        const [owner] = await ethers.getSigners();
        const CertificadoIT = await ethers.getContractFactory("CertificadoIT")
        const deployed = await CertificadoIT.deploy();

        return {
            owner,
            deployed
        }
    }

    describe('Minting', () => {
        it('Mint a new token and assigns it to owner', async () => {
            const nombre = "Lautaro Nahuel Gonzalez";
            const nick = "Laucha";
            const curso = "Blockchain";
            const institucion = "UTN";

            const { owner, deployed } = await setup({});

            await deployed.mint(nombre, nick, curso, institucion);
            
            console.log(deployed.ownerOf(0));
            console.log(owner.address);

            const ownerOfMinted = await deployed.ownerOf(0);

            expect(ownerOfMinted).to.equal(owner.address);
        })
    })
})