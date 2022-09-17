    //SPDX-License-Identifier: MIT
    pragma solidity ^0.8.4;
    
    //importing from openzeppeline.

    import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
    import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
    import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
    import "@openzeppelin/contracts/security/Pausable.sol";
    import "@openzeppelin/contracts/access/Ownable.sol";

    contract ChimpsNFT is ERC721, ERC721Enumerable, ERC721URIStorage, Pausable, Ownable {
    
    //State variables

    uint public totalLimit = 100;
    uint public mintLimit = 90;
    uint public whiteListedLimit = 50;
    uint public publicLimit = 40;
    uint public platformLimit = totalLimit - mintLimit;
    uint public mintedNFTs;
    uint public whitelistedMintedNFTs;
    uint public pltformMintindNFTs;
    uint public publicMintedNFTs;
    uint public whiteNonMintBalance; 
    string public baseURI;
    bool public publicSale;
    bool public mintDisabled;
    address[] public whitelistedAddresses;
    
    struct nftInfo{
    uint   Id;
    string Name;
    string MetaDataHash;
    }

    mapping(uint => nftInfo) public nftData;
    mapping(address => bool) public whiteListedUsers;
    mapping(address => uint) public perAddressMinting;
    mapping(address => bool) public whiteListedAdmins;

    error perAddressLimit(string);
    error totalMintLimit(string);
    error notWhitelistedAdmin(string);
    error notWhitelistedUser(string);
    error whitelistedUserLimit(string);
    error publicSaleStatus(string);
    error publicMintLimit(string);
    error platformMintLimit(string);
    error MintingDisabled();
  
   
    event AddedWhitelistAdmin(
        address whitelistedAddress,
        address updatedBy
    );

      event WhitelistedUser(
        address _sender, 
        address _user, 
        bool _status);

    event RemovedWhitelistAdmin(
        address whitelistedAddress,
        address updatedBy
    );

    event publicSaleEvent(
        address _sender, 
        bool _status
    );
         
    event updateUri(
        address _sender,
        string _uri
    );

    event addAdminEvent(
        address _admin,
        bool _status
    );

    
    constructor() ERC721("ChimpsNFT", "CH1") {
         baseURI= "https://gateway.pinata.cloud/ipfs/";
    }        
  
    //* mintStatusCheck() to stop miniting functions

    modifier mintStatusCheck() {
         if (mintDisabled == true) {
            revert MintingDisabled();
        }
        _;
    }
    
    //* preSaleCheck() and publicSaleCheck() checks represent start or end preSale.

    modifier preSaleCheck() {
          if (publicSale == true){
           revert publicSaleStatus("preSaleEnd");
        }
        _;
    }

    modifier publicSaleCheck() {
          if (publicSale == false){
          revert publicSaleStatus("publicSaleNotStarted");
        }
        _;
    }
    
    //* pause() or unpause() All contract functions can be paused by contract owner. 

    function pause() 
      public 
      onlyOwner {
     _pause();
    }

    function unpause() 
      public 
      onlyOwner {
      _unpause();
    }

    /*NFTs will be reserved with respect to limit i.e. 1 address can mint up to 5 NFTs.
    *toalLimtit=100
    */

    function safeMint(
        address to,
        uint256 nftId,
        string memory name, 
        string memory _hash
        ) private 
         mintStatusCheck {
        require(!paused(), "Pausable: paused");

        if(mintedNFTs < totalLimit) {
        if (perAddressMinting[msg.sender] < 5) {  
           _safeMint(to, nftId);
           _setTokenURI(nftId, string(abi.encode(baseURI, _hash)));
            nftData[nftId]= nftInfo(nftId, name, _hash); 
            perAddressMinting[msg.sender] += 1;
            mintedNFTs += 1;
              }
        else {
                revert perAddressLimit("Minting limit of 5 NFTs per address is reached");
            }
        }
        else {
                revert totalMintLimit("Total minting limit is reached");
        }
    }
    
    /*Only WhiteListed users can mint whiteListedMinting
    * when publicSale active whitelist users cannot mint the NFTs. 
    * WhiteListed user Limit 50
    */

    function whitelistedMinting(
        address to,
        uint  nftId, 
        string memory name, 
        string memory _hash
        ) public 
        preSaleCheck {
        require(!paused(), "Pausable: paused");

        if (whitelistedMintedNFTs < whiteListedLimit) {
        if (whiteListedUsers[msg.sender]) {
            safeMint(to, nftId, name, _hash);
            whitelistedMintedNFTs += 1;
            }
        else {
                revert notWhitelistedUser("Not a whitelisted user");
            }
        }
        else {
            revert whitelistedUserLimit("Whitelisted user minting limit is reached");
        }
    }
    
    /* Whitelist addresses can be mint as public.
    * Public users cannot mint NFTs if public sales are not active.
    * Remaining NFTs of whiteListed users will be added to the public limit if you are active the public sales. 
    * PublicLimit 40.
    */

    function publicMinting(
        address to,
        uint  nftId, 
        string memory name, 
        string memory _hash) 
        public 
        publicSaleCheck {       
        require(!paused(), "Pausable: paused");     
        
        if (publicMintedNFTs < publicLimit) {
            safeMint(to, nftId, name, _hash); 
            publicMintedNFTs += 1;
            }
        else {
            revert publicMintLimit("Public minting limit is reached");
        }
    }

    //* platFormMinting only done by whiteListedAdmins in limit of 10.

    function platFormMinting(
        address to, 
        uint  nftId, 
        string memory name, 
        string memory _hash
        ) public {
        require(!paused(), "Pausable: paused");
        
    if(pltformMintindNFTs <= platformLimit) {
    if(whiteListedAdmins[msg.sender]) {
        safeMint(to, nftId, name, _hash); 
        pltformMintindNFTs += 1;
    }
    else {
            revert notWhitelistedAdmin("Not a whitelisted admin");
            }
        }
    else {
            revert platformMintLimit("Platform minting limit is reached");
        }
    }
    
    //* @param_status whitelist admins that can be only add or remove by the owner of the contract.

    function addWhiteListedAdmin(
        address _address, 
        bool _status
        ) public 
        onlyOwner {
        require(!paused(), "Pausable: paused");

        whiteListedAdmins[_address] = _status;
        emit addAdminEvent(_address, _status);
    }
    
     /**
     * @dev setBaseUri is used to update BaseURI.
     * Requirement:
     * - This function can only called by owner of whiteListedAdmins
     */

    function setBaseUri(
        string memory _uri
        ) public {
        require(!paused(), "Pausable: paused");

        if(whiteListedAdmins[msg.sender]) {
            baseURI = _uri;
            emit updateUri(msg.sender, _uri);
        }
        else {
            revert notWhitelistedAdmin("Not a whitelisted admin");
        }
    }

    function _beforeTokenTransfer(
        address from, 
        address to, 
        uint256 tokenId
        )internal 
        whenNotPaused 
        override (ERC721, ERC721Enumerable) {
        require(!paused(), "Pausable: paused");

        super._beforeTokenTransfer(from, to, tokenId);
    }
    
    function _burn(
        uint256 tokenId
        ) internal 
        override(ERC721, ERC721URIStorage) {
        require(!paused(), "Pausable: paused");

        super._burn(tokenId);
    }

     /*
     * @dev tokenURI is used to get tokenURI link.
     *
     * @param _tokenId - ID
     *
     * @return string .
     */

    function tokenURI(
        uint256 tokenId
        ) public 
        view 
        override (ERC721, ERC721URIStorage)
        returns (string memory) {
        require(!paused(), "Pausable: paused");

        return string(abi.encodePacked(baseURI, nftData[tokenId].MetaDataHash));
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool) {
        require(!paused(), "Pausable: paused");

        return super.supportsInterface(interfaceId);
    }

    /*
     * @dev setMintStatus is used to update minting status.
     * Requirement:
     * - This function can only called by owner of the Contract
    
    */

    function setMintStatus(bool _state) 
      public 
      onlyOwner {
      require(!paused(), "Pausable: paused");
      
      mintDisabled = _state;
    }

    //* addWhitelistedUser to add or remove User to WhiteListedMint 

    function addWhitelistedUser(
       address _address, 
       bool _status
       ) public {
       require(!paused(), "Pausable: paused");

        if(whiteListedAdmins[msg.sender]) {
            whiteListedUsers[_address] = _status;
            emit WhitelistedUser(msg.sender, _address, _status);
        }
        else {
            revert notWhitelistedAdmin("Not a whitelisted admin");
        }
    }

    /* Requirements:
    * Only owner can call this function.
    * @param_stauts to start or end sale.
    * setPublicSale bool=true (remaining mintLimit of whiteListed users transfer to publicLimit.)
    */
    
    function setPuclicSale(bool _status) 
      public 
      onlyOwner {
      require(!paused(), "Pausable: paused");

      publicSale = _status;

      if (publicSale == true) {
            whiteNonMintBalance = whiteListedLimit - whitelistedMintedNFTs;
            publicLimit += whiteNonMintBalance;
        }
          emit publicSaleEvent(msg.sender, _status);
     }

    }
