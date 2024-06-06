// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";

contract ContractVV2 is ERC721A, Context {
    struct Creature {
        uint256 id;
        address owner;
        // bit positions:
        // [0 - 63] strength
        // [64 - 127] agility
        // [128 - 191] intelligence
        // [192 - 255] specialPower
        uint256 gameStats;
        // bit positions:
        // [0 - 127] wins
        // [128 - 255] losses
        uint256 battleRecord;
    }

    uint256 private nextCreatureId;
    mapping (uint256 => Creature) private creatures;

    event CreatureCreated(uint256 indexed creatureId, address indexed owner);
    event BattleResult(uint256 indexed winnerId, uint256 indexed loserId);

    // bit positions and masks for `gameStats`
    uint256 private constant STRENGTH_BITPOS = 0;
    uint256 private constant AGILITY_BITPOS = 64;
    uint256 private constant INTELLIGENCE_BITPOS = 128;
    uint256 private constant SPECIAL_POWER_BITPOS = 192;

    // bit positions for `battleRecord`
    uint256 private constant WINS_BITPOS = 0;
    uint256 private constant LOSSES_BITPOS = 128;

    error CreatureDoesntExist();
    error CreatureNotOwned();

    modifier onlyOwnedCreature(uint256 id) {
        _checkCreatureOwned(id);

        _;
    }

    constructor() ERC721A("Digiture", "DGT") {
        nextCreatureId = 1;
    }

    function getNextCreatureId() external view returns (uint256) {
        return nextCreatureId;
    }

    function getCreature(uint256 id) external view returns (Creature memory) {
        return creatures[id];
    }

    // `public` so that it can also be called via external methods
    function unpackBattleRecord(uint256 battleRecord) public pure returns (uint256 wins, uint256 losses) {
        assembly {
            // equivalent to (battleRecord >> WINS_BITPOS) & ((1 << 128) - 1);
            wins := and(shr(WINS_BITPOS, battleRecord), sub(shl(128, 1), 1))
            // equivalent to (battleRecord >> LOSSES_BITPOS) & ((1 << 128) - 1);
            losses := and(shr(LOSSES_BITPOS, battleRecord), sub(shl(128, 1), 1))
        }
    }

    // please note that each variable can only support up to 2^128 - 1.
    // to reduce gas costs, no explicit conversion is added here, and it's up to the dev/user
    // to ensure no overflow exists.
    function packBattleRecord(uint256 wins, uint256 losses) internal pure returns (uint256 battleRecord) {
        assembly {
            // equivalent to (wins << WINS_BITPOS) | (losses << LOSSES_BITPOS);
            battleRecord := 
                or(
                    shl(WINS_BITPOS, wins),
                    shl(LOSSES_BITPOS, losses)
                )
        }
    }

    // assumes that `gameStats` is calculated off-chain
    function mintCreature(uint256 gameStats) external {
        creatures[nextCreatureId] = Creature(
            nextCreatureId,
            _msgSender(),
            gameStats,
            0
        );

        unchecked {
            _safeMint(_msgSender(), 1);
            emit CreatureCreated(nextCreatureId, _msgSender());
        }

        assembly {
            sstore(
                nextCreatureId.slot, 
                add(
                    sload(nextCreatureId.slot), 
                    1
                )
            )
        }
    }

    // very simple logic to record the battle result (not requiring proof)
    // only requirement is that creatures exist and that the `winnerId` creature is owned by the caller
    function recordBattleResult(uint256 winnerId, uint256 loserId) external onlyOwnedCreature(winnerId) {
        _checkCreatureExists(winnerId);
        _checkCreatureExists(loserId);

        Creature storage winner = creatures[winnerId];
        Creature storage loser = creatures[loserId];

        (uint256 winnerWins, uint256 winnerLosses) = unpackBattleRecord(winner.battleRecord);
        (uint256 loserWins, uint256 loserLosses) = unpackBattleRecord(loser.battleRecord);

        assembly {
            winnerWins := add(winnerWins, 1)
            loserLosses := add(loserLosses, 1)
        }

        winner.battleRecord = packBattleRecord(winnerWins, winnerLosses);
        loser.battleRecord = packBattleRecord(loserWins, loserLosses);
        emit BattleResult(winnerId, loserId);
    }

    function _checkCreatureOwned(uint256 id) private view {
        if (creatures[id].owner != _msgSender()) revert CreatureNotOwned();
    }

    function _checkCreatureExists(uint256 id) private view {
        if (creatures[id].owner == address(0)) revert CreatureDoesntExist();
    }
}