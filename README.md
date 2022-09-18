# NFT Smart-Contract to mint NFTs using Public/WhiteListed/Admin access mint Features

**Deployed on Polygon testnet**
**Contract Address:** 0x1A21a63F3E20dE22b71935f6f55F3606e3920891

 ### My NFT collection minted with ERC721 Smart Contract.
 - **Pinata IPFS is used to generate Metadata of NFT's**
 
 - **Opensea_Link:** https://testnets.opensea.io/collection/chimps

**NFT Contract Requirements**

- ERC-721 Compliance Compatible

### Users will be

- Whitelisted users

- Public users

### NFT  Minting Limit

- Total Minting Limit

- Whitelisted users Minting Limit

- Public users Minting Limit

- Platform Minting (admin) Limit
            
- Whitelist User Minting:

Only whitelist users are allowed to mint the NFTs.

If the Whitelist User's Minting limit is reached then whitelist users cannot mint the NFTs.

- Public Minting:

Public Minting is only available when public sales are active.

If the public minting limit is reached then public cannot mint the NFTs.

- Platform Minting:

Platform minting is for platfrom admins only.

If the platform limit is reached admins cannot mint NFTs.

## What we need as deliveries:

1. NFTs will be reserved with respect to limit i.e. 1 address can mint up to 5 NFTs.

2. Contract will also have whitelisted admins that can be added or removed by the owner of the contract only.

3. Default Base URI will be set or updated by whitelisted admins only.

4. Contract will have a pause/un-pause minting feature. Minting status can be changed by the owner of the contract.

5. Token Ids will not be managed within the contract. It will be passed as a parameter in the minting function.

6. Contract stores the following attributes of NFTs:

- ID
- Name
- Metadata hash

7. Whitelisted addresses can mint as public users. We’ll define a limit for each user that will include whitelisted and public minting.

8. Whitelisted admins cannot mint NFTs if the minting status is paused.

9. Public users cannot mint NFTs if public sales are not active.

10. We have reserved a limit for each Admin, Whitelisted user, and public.

11. Let's say we have a total minting limit is 100. In which you reserved 10 for admins and 50 for whitelist users. The remaining limit is 40. So 40 limit will be reserved for public sales. If whitelist users only mint 40 NFTs out of 50 remaining 10 NFTs will be added to the public limit if you are active the public sales. Furthermore, when you activate the public sale then whitelist users cannot mint the NFTs.   
