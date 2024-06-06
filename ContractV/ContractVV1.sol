// SPDX-License-Identifier: MIT

pragma solidity ^0.8.25;

import "https://github.com/chiru-labs/ERC721A/blob/main/contracts/ERC721A.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Context.sol";

contract ContractVV1 is ERC721A, Context {
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

    // please note that each variable can only support up to 2^64 - 1.
    // to reduce gas costs, no explicit conversion is added here, and it's up to the dev/user
    // to ensure no overflow exists.
    function packGameStats(
        uint256 strength, 
        uint256 agility, 
        uint256 intelligence, 
        uint256 specialPower
    ) internal pure returns (uint256 gameStats) {
        assembly {
            // equivalent to (strength << STRENGTH_BITPOS) |
            // (agility << AGILITY_BITPOS) |
            // (intelligence << INTELLIGENCE_BITPOS) |
            // (specialPower << SPECIAL_POWER_BITPOS);
            gameStats := 
                or(
                    or(
                        or(
                            shl(STRENGTH_BITPOS, strength),
                            shl(AGILITY_BITPOS, agility)
                        ),
                        shl(INTELLIGENCE_BITPOS, intelligence)
                    ),
                    shl(SPECIAL_POWER_BITPOS, specialPower)
                )
        }
    }

    // `public` so that it can also be called via external methods
    function unpackGameStats(uint256 gameStats) public pure returns (
        uint256 strength,
        uint256 agility,
        uint256 intelligence,
        uint256 specialPower
    ) {
        assembly {
            // equivalent to: (gameStats >> xxx_BITPOS) & ((1 << 64) - 1);
            strength := and(shr(STRENGTH_BITPOS, gameStats), sub(shl(64, 1), 1))
            agility := and(shr(AGILITY_BITPOS, gameStats), sub(shl(64, 1), 1))
            intelligence := and(shr(INTELLIGENCE_BITPOS, gameStats), sub(shl(64, 1), 1))
            specialPower := and(shr(SPECIAL_POWER_BITPOS, gameStats), sub(shl(64, 1), 1))
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

    // `public` so that it can also be called via external methods
    function unpackBattleRecord(uint256 battleRecord) public pure returns (uint256 wins, uint256 losses) {
        assembly {
            // equivalent to (battleRecord >> WINS_BITPOS) & ((1 << 128) - 1);
            wins := and(shr(WINS_BITPOS, battleRecord), sub(shl(128, 1), 1))
            // equivalent to (battleRecord >> LOSSES_BITPOS) & ((1 << 128) - 1);
            losses := and(shr(LOSSES_BITPOS, battleRecord), sub(shl(128, 1), 1))
        }
    }

    function createRandomCreature() external {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.prevrandao, _msgSender())));

        creatures[nextCreatureId] = Creature(
            nextCreatureId,
            _msgSender(),
            // sample calculation to obtain strength, agility, intelligence and special power
            packGameStats(
                rand % 1000,
                (rand / 1000) % 1000,
                (rand / 1000000) % 1000,
                (rand / 1000000000) % 1000
            ),
            packBattleRecord(0, 0)
        );

        unchecked {
            _safeMint(_msgSender(), 1);
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

        emit CreatureCreated(nextCreatureId, _msgSender());
    }

    // simple battle functionality
    function battle(uint256 ownerCreatureId, uint256 opponentCreatureId) external onlyOwnedCreature(ownerCreatureId) {
        (uint256 ownerStrength, uint256 ownerAgility, uint256 ownerIntelligence, uint256 ownerSpecialPower) = unpackGameStats(creatures[ownerCreatureId].gameStats);
        (uint256 opponentStrength, uint256 opponentAgility, uint256 opponentIntelligence, uint256 opponentSpecialPower) = unpackGameStats(creatures[opponentCreatureId].gameStats);

        // we assume a win is only if the owner OVERPOWERS the opponent (lesser or equal to the opponent results in a loss)
        if (ownerStrength + ownerAgility + ownerIntelligence + ownerSpecialPower > opponentStrength + opponentAgility + opponentIntelligence + opponentSpecialPower) {
            _updateBattleRecord(ownerCreatureId, true);
            _updateBattleRecord(opponentCreatureId, false);
            emit BattleResult(ownerCreatureId, opponentCreatureId);
        } else {
            _updateBattleRecord(ownerCreatureId, false);
            _updateBattleRecord(opponentCreatureId, true);
            emit BattleResult(ownerCreatureId, opponentCreatureId);
        }
    }

    function _checkCreatureOwned(uint256 id) private view {
        if (creatures[id].owner != _msgSender()) revert CreatureNotOwned();
    }

    function _updateBattleRecord(uint256 creatureId, bool won) private {
        Creature storage creature = creatures[creatureId];
        (uint256 wins, uint256 losses) = unpackBattleRecord(creature.battleRecord);

        assembly {
            switch won
            case true { wins := add(wins, 1) }
            default { losses := add(losses, 1) }
        }

        creature.battleRecord = packBattleRecord(wins, losses);
    }
}