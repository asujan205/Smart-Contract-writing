// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
contract NftMarket is ERC721URIStorage, Ownable {
  using Counters for Counters.Counter;
   Counters.Counter private _itemsSold;
  Counters.Counter private _tokenIds;
//address payable owner;

  struct NftItem {
    uint tokenId;
    uint price;
    address payable seller;
    address payable owner;
    bool sold;
  }
   uint256 public listingPrice = 0.025*10**18;

  mapping(uint => NftItem) private _idToNftItem;

   event NftItemCreated (
    uint indexed tokenId,
    uint price,
    address  seller,
    address  owner,
    bool sold
  );
  bool comapredValue = false;
  event IsCompared (
    bool comapredValue
  );
constructor() ERC721("CreaturesNFT", "CNFT") {
  //owner= payable(msg.sender);
    
}
 function setListingPrice(uint newPrice) public payable onlyOwner {
    require(newPrice > 0, "Price must be at least 1 wei");
    listingPrice = newPrice;
  }
  function getListinPrice() public view returns(uint256){
 return listingPrice;
  }
  
  //CreateNft Function
 function createNft(string memory tokenURI, uint256 price) public payable returns (uint256)
 
 {
 _tokenIds.increment();
 uint256 newId= _tokenIds.current();
 _mint(msg.sender,newId);
 _setTokenURI(newId,tokenURI);
 createMarketItem(newId,price);

 return newId;


 }
//  private function that create NftiTEMS after NftTokEN Minted
function createMarketItem(uint256 newId,uint256 price) private{
  require(price>0,"price must have some of the value");

  require(msg.value== listingPrice,"price should be equal to listing price");
  _idToNftItem[newId]=NftItem(
    newId,
    price,
    payable(msg.sender),
    payable(address(this)),
    false


  );

_transfer(msg.sender,address(this),newId);
emit NftItemCreated (newId,price,msg.sender,address(this),false);
  
  
}
// function for resell token okey.!!...


function reSellToken(uint256 tokenId ,uint256 Newprice) public payable {
  require(_idToNftItem[tokenId].owner== msg.sender,"You are not owner bitch");
  require(_idToNftItem[tokenId].sold == true, "Item is already on sold k bro");
  require(msg.value == listingPrice, "Price must be equal to listing price");
  _idToNftItem[tokenId].price=Newprice;
  _idToNftItem[tokenId].seller=payable(msg.sender);
  _idToNftItem[tokenId].owner=payable(address(this));
  _idToNftItem[tokenId].sold=false;
  _itemsSold.decrement();
  _transfer(msg.sender,address(this),tokenId);
}

// function to create MarketSell
function createMarketSell(uint256 tokenId) public payable{
  uint256 price = _idToNftItem[tokenId].price;
  require(msg.value== price ,"hiya milna parcha kiya bhai tesko price tah hunu paryonita");
  _idToNftItem[tokenId].owner=payable(msg.sender);//whoever calling the function should be new owner 
  _idToNftItem[tokenId].sold=true;
  _idToNftItem[tokenId].seller=payable(address(0));
  _itemsSold.increment();
  _transfer(address(this),msg.sender,tokenId);
  payable(Ownable.owner()).transfer(listingPrice);
  payable(_idToNftItem[tokenId].seller).transfer(msg.value);




}

//Fetching items procedure from  here...

//Getting unsold Nft 
function fectchMarketNft() public view returns(NftItem[] memory){
  uint256 allItemsCounts = _tokenIds.current();
  uint256 unSoldItemCounts = _tokenIds.current() -_itemsSold.current();
  uint256 currentIndex=0;
  NftItem[] memory Items = new NftItem[](unSoldItemCounts);// i want to fetch only onsold on
  for (uint256 i =0; i< allItemsCounts; i++){
    if(_idToNftItem[i+1].owner== address(this)){
      uint256 currentId= i+1;
      NftItem storage currentItem= _idToNftItem[currentId];
      Items[currentIndex]=currentItem;
      currentIndex+=1;


    }
    
  }

  return Items;





}
// ma sanga bhako owned gareko nft cahi cahiyena?

function fetchMyNft() public view returns(NftItem[] memory){
  uint256 TotalCount = _tokenIds.current();
  uint256 ItemCount =0;
  uint256 currentIndex=0;
  for (uint256 i=0; i<TotalCount; i++){
    if(_idToNftItem[i+1].owner== msg.sender){
      ItemCount+=1;


    }

 
  }
  NftItem[] memory Items= new NftItem[](ItemCount);
 for (uint256 i =0; i< TotalCount; i++){
    if(_idToNftItem[i+1].owner== msg.sender){
      uint256 currentId= i+1;
      NftItem storage currentItem= _idToNftItem[currentId];
      Items[currentIndex]=currentItem;
      currentIndex+=1;


    }
 }
return Items;

} 
// single user item..
function fetchItemsListed() public view returns(NftItem[] memory){
  uint256 TotalCount =_tokenIds.current();
  uint256 ItemCount = 0;
  uint256 currentIndex =0;
  for (uint256 i=0; i< TotalCount ; i++){
    if(_idToNftItem[i+1].seller == msg.sender){
      ItemCount+=1;
    }
  }
  NftItem[] memory Items = new NftItem[](ItemCount);
  for (uint256 i =0; i< TotalCount; i++){
    if(_idToNftItem[i+1].seller== msg.sender){
      uint256 currentId= i+1;
      NftItem storage currentItem= _idToNftItem[currentId];
      Items[currentIndex]=currentItem;
      currentIndex+=1;


    }
 }
return Items;

}




}
