// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./Base64.sol";


contract CertificadoIT is ERC721, ERC721Enumerable {

    struct certificado{
        string nombre;
        string nick;
        string curso;
        string institucion;
    }

    using Counters for Counters.Counter;

    Counters.Counter private _idCounter;
    certificado private certificadoOficial;

    constructor() ERC721("CertificadoIT", "CTFIT") {}

    function mint(string memory _nombre,string memory _nick,string memory _curso,string memory _institucion) public {
        uint256 current = _idCounter.current();
        certificadoOficial.nombre = _nombre;
        certificadoOficial.nick = _nick;
        certificadoOficial.curso = _curso;
        certificadoOficial.institucion = _institucion;
        _safeMint(msg.sender, current);
    }

    function _baseURI() internal pure override returns(string memory){
        return "https://avataaars.io/";
    }

    function _paramURI(string memory _nombre, string memory _institucion, string memory _curso) internal pure returns (string memory) {
        string memory params;

        params = string(abi.encodePacked(
            "name=",
            _nombre,
            "&intitution=",
            _institucion,
            "&course=",
            _curso
        ));

        return params;
    }

    function imageCertificate(string memory _nombre, string memory _instituto, string memory _curso) public pure returns (string memory){
        string memory baseURI = _baseURI();
        string memory paramsURI = _paramURI(_nombre, _instituto, _curso);

        return string(abi.encodePacked(baseURI, "?", paramsURI));
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        require(_exists(tokenId), "ERC721 Metadata: URI query for nonexistint token");

        string memory image = imageCertificate(certificadoOficial.nick, certificadoOficial.institucion, certificadoOficial.curso);

        string memory jsonURI = Base64.encode(
                abi.encodePacked(
                    '{ "name": "CertificadoIT #', 
                    Strings.toString(tokenId),
                    '", "description": "Certificado de curso IT", "image": "',
                    image,
                    '", "attributes": [{"Nombre": "',
                    certificadoOficial.nombre,
                    '" ,"Nick": "',
                    certificadoOficial.nick,
                    '", "Curso":"',
                    certificadoOficial.curso,
                    '","Institucion":"',
                    certificadoOficial.institucion,
                    '"}]'
                    '}'
                )
            );

        return string(abi.encodePacked("data:application/json;base64,",jsonURI));
    }


    // Override required
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}