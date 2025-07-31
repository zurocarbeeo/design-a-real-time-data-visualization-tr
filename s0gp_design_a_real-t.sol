pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";

contract RealTimeDataVisualizationTracker {
    using SafeMath for uint256;

    struct Track {
        string metricName;
        uint256 timestamp;
        uint256 value;
    }

    mapping (address => Track[]) public tracks;

    event NewTrackAdded(address indexed _addr, string _metricName, uint256 _timestamp, uint256 _value);

    function addTrack(string memory _metricName, uint256 _value) public {
        Track memory newTrack = Track(_metricName, block.timestamp, _value);
        tracks[msg.sender].push(newTrack);
        emit NewTrackAdded(msg.sender, _metricName, block.timestamp, _value);
    }

    function getTracks(address _addr) public view returns (Track[] memory) {
        return tracks[_addr];
    }

    function getRecentTracks(address _addr, uint256 _numberOfRecentTracks) public view returns (Track[] memory) {
        Track[] memory recentTracks = new Track[](_numberOfRecentTracks);
        Track[] storage userTracks = tracks[_addr];
        for (uint256 i = 0; i < _numberOfRecentTracks; i++) {
            recentTracks[i] = userTracks[userTracks.length - 1 - i];
        }
        return recentTracks;
    }
}