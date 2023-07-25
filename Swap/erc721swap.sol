// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.2;

contract TokenSwap is Ownable, ERC721Holder {
    uint256 private _swapIdx;
    uint256 private _ethLocked;
    uint256 private _fee;

    struct Swap {
        address payable owner1;
        address payable owner2;
        address nftContract1;
        uint256 tokenId1;
        address nftContract2;
        uint256 tokenId2;
        bool isSwapped;
    }

    mapping(uint256 => Swap) private _swaps;

    event SwapCreated(
        address indexed owner1,
        address indexed owner2,
        uint256 indexed id,
        address nftContract1,
        uint256 tokenId1,
        address nftContract2,
        uint256 tokenId2
    );

    event SwapCompleted(
        address indexed owner1,
        address indexed owner2,
        uint256 indexed id,
        address nftContract1,
        uint256 tokenId1,
        address nftContract2,
        uint256 tokenId2
    );

    event SwapCancelled(
        address indexed owner1,
        address indexed owner2,
        uint256 indexed id
    );

    event SwapRejected(
        address indexed owner1,
        address indexed owner2,
        uint256 indexed id
    );

    event FeeChange(uint256 fee);

    modifier onlySwapCreator(uint256 swapId) {
        require(
            _swaps[swapId].owner1 == msg.sender,
            "Only swap creator can call this function"
        );
        _;
    }

    constructor(uint256 fee) {
        _fee = fee;
        super.transferOwnership(msg.sender);
    }

    function getFee() external view returns (uint256) {
        return _fee;
    }

    function changeFee(uint256 fee) external onlyOwner {
        _fee = fee;
        emit FeeChange(_fee);
    }

    function getSwap(uint256 id)
        external
        view
        returns (Swap memory)
    {
        return _swaps[id];
    }

    function createSwap(address _owner2, address _nftContract1, uint256 _tokenId1, address _nftContract2, uint256 _tokenId2)
        public
        payable
    {
        require(msg.value >= _fee, "Fee not provided");
     require(IERC721(_nftContract1).ownerOf(_tokenId1) == msg.sender, "You are not the owner of the NFT");
      require(IERC721(_nftContract2).ownerOf(_tokenId2) == _owner2, "Receiver is not the owner of NFT 2");
        _swapIdx += 1;
        _ethLocked += msg.value;

        Swap storage swap = _swaps[_swapIdx];
        swap.owner1 = payable(msg.sender);
        swap.owner2 = payable(_owner2);
        swap.nftContract1 = _nftContract1;
        swap.tokenId1 = _tokenId1;
        swap.nftContract2 = _nftContract2;
        swap.tokenId2 = _tokenId2;
        swap.isSwapped = false;

        emit SwapCreated(
            swap.owner1,
            swap.owner2,
            _swapIdx,
            swap.nftContract1,
            swap.tokenId1,
            swap.nftContract2,
            swap.tokenId2
        );
    }

    function acceptSwap(uint256 id) external payable {
        Swap storage swap = _swaps[id];
        require(swap.owner2 == msg.sender, "Only swap acceptor can call this function");
        require(swap.isSwapped == false, "Swap already completed");

        require(msg.value >= _fee, "Fee not provided");

        _ethLocked += msg.value;

        IERC721(swap.nftContract1).safeTransferFrom(swap.owner1, swap.owner2, swap.tokenId1);
        IERC721(swap.nftContract2).safeTransferFrom(swap.owner2, swap.owner1, swap.tokenId2);

        swap.isSwapped = true;

        emit SwapCompleted(
            swap.owner1,
            swap.owner2,
            id,
            swap.nftContract1,
            swap.tokenId1,
            swap.nftContract2,
            swap.tokenId2
        );
    }

    function rejectSwap(uint256 id) external {
        Swap storage swap = _swaps[id];
        require(swap.owner2 == msg.sender, "Only swap acceptor can call this function");
        require(swap.isSwapped == false, "Swap already completed");

        _ethLocked -= _fee;

        IERC721(swap.nftContract1).safeTransferFrom(address(this), swap.owner1, swap.tokenId1);
        IERC721(swap.nftContract2).safeTransferFrom(address(this), swap.owner2, swap.tokenId2);

        emit SwapRejected(
            swap.owner1,
            swap.owner2,
            id
        );

        delete _swaps[id];
    }

    function cancelSwap(uint256 id) external {
        Swap storage swap = _swaps[id];
        require(swap.owner1 == msg.sender, "Only swap creator can call this function");
        require(swap.isSwapped == false, "Swap already completed");

        _ethLocked -= _fee;

        IERC721(swap.nftContract1).safeTransferFrom(address(this), swap.owner1, swap.tokenId1);
        IERC721(swap.nftContract2).safeTransferFrom(address(this), swap.owner2, swap.tokenId2);

        emit SwapCancelled(
            swap.owner1,
            swap.owner2,
            id
        );

        delete _swaps[id];
    }

    function withdrawFees() external onlyOwner {
        require(_ethLocked > 0, "No locked ETH");

        uint256 amount = _ethLocked;
        _ethLocked = 0;

        payable(owner()).transfer(amount);
    }
}