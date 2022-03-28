pragma solidity ^0.4.20;

contract DeletableMapping {
    // Input is keccak256(uint32 mappingVersion, string carVIN)
    mapping (bytes32 => string) carfaxReports;
    uint32 currentMappingVersion;

    function getCarfaxReport(string _carVIN) external view returns(string) {
        bytes32 key = keccak256(currentMappingVersion, _carVIN);
        return carfaxReports[key];
    }

    function setCarfaxReport(string _carVIN, string _reportJSON) external {
        bytes32 key = keccak256(currentMappingVersion, _carVIN);
        carfaxReports[key] = _reportJSON;
    }

    function deleteAllReports() external {
        currentMappingVersion++;
    }

    function recoverGas(uint32 _version, string _carVIN) external {
        require(_version < currentMappingVersion);
        bytes32 key = keccak256(_version, _carVIN);
        delete(carfaxReports[key]);
    }
}
