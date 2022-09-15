# ERC721_mintSaleContract
NFT Smart-Contract to mint NFTs

**NFT Contract Requirements**

ERC-721 Compliance Compatible

Users will be      
"⋅"Whitelisted user
"⋅"Public
"⋅"NFT  Minting Limit
Total Minting Limit         
Whitelisted users Minting         
Public users Minting         
Platform Minting (admin)
            
1: Whitelist User Minting: 
Only whitelist users allow to mint the NFT.
If the Whitelist User's Minting limit is reached then whitelist users cannot mint the NFTs.
2: Public Minting:
Public Minting is only available when public sales are active.
If the public minting limit is reached then users cannot mint the NFTs.   
3: Platform Minting: 
Platform minting is for admin addresses. 
If the platform limit is reached admin cannot mint more NFTs.
What I need as deliveries:
NFTs will be reserved with respect to limit i.e. 1 address can mint up to 5 NFTs.
Contract will also have whitelist admins that can be only add or remove by the owner of the contract.
All contract functions can be paused by contract owner.   
Default Base URI will be set or update by whitelist admins.
Contract will have a pause/un-pause minting feature. Minting status can be changed by the owner of the contract.
Token Ids will not be managed within the contract. It will be pass as a parameter in the minting function.
We need to store the following attributes in our NFT contract:
                          1: ID
                          2: Name 
                          3: Metadata hash   
Whitelist addresses can be mint as public. We’ll define a limit for each user that will include whitelist and public minting.
Whitelist admins cannot mint NFTs if the minting status is paused.
Public users cannot mint NFTs if public sales are not active.  
We have reserved a limit for each Admin, Whitelist user, and public.
Let's say we have a total minting limit is 100. In which you reserved 10 for admins and 50 for whitelist users. The remaining limit is 40. So 40 limit will be reserved for public sales. If whitelist users only mint 40 NFTs out of 50 remaining 10 NFTs will be added to the public limit if you are active the public sales. Furthermore, when you activate the public sale then whitelist users cannot mint the NFTs.   
