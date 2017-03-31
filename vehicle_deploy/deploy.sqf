private["_type", "_requiredParts", "_displayName", "_canSell", "_removeAmmo", "_combat", "_canDeployVehicle", "_nearestPlots", "_nearbyPlots", "_reasonText", "_animation"];

_type = _this select 0;

_canDeployVehicle = false;
_reasonText = "";

closedialog 1;

#include "config.sqf"

_deployInfo = _type call _getDeployConfig;

_requiredParts = _deployInfo select 0;
_displayName = _deployInfo select 1;
_canSell = _deployInfo select 2;
_removeAmmo = _deployInfo select 3;
_combat = _deployInfo select 4;
_animation = _deployInfo select 5;

_checkRequirements = [_requiredParts, _displayName, _combat] call _deployCheckRequirements;

_canDeployVehicle = _checkRequirements select 0;
_reasonText = _checkRequirements select 1;

if (_canDeployVehicle) then {
    private["_dir", "_location", "_object", "_id", "_finished"];

    [player, "repair", 0, false, 10] call dayz_zombieSpeak;
    [player, 10, true, (getPosATL player)] spawn player_alertZombies;
	
	_finished = true;
	
	if (_animation) then {
		_finished = [_displayName, "deploy"] call _playerDoLoop;
	};
	
	if (_finished) then {
		{
			private["_remove", "_removeAmount"];
			_remove = _x select 0;
			_removeAmount = _x select 1;
		
			if (isClass(configFile >> "CfgWeapons" >> _remove)) then {
				private "_i";
				for "_i" from 1 to _removeAmount do {
					player removeWeapon _remove;
				};
			} else {
				private "_i";
				for "_i" from 1 to _removeAmount do {
					player removeMagazine _remove;
				};
			};
		} forEach _requiredParts;
		
		_dir = getdir player;
		_location = getPosATL player;
		_location = [(_location select 0) + 3 * sin(_dir), (_location select 1) + 3 * cos(_dir), (_location select 2) + 1];
		
		_object = createVehicle[_type, _location, [], 0, "CAN_COLLIDE"];
		_object setPosATL _location;
		_object setvelocity [0,0,1];
		_object setDir ((getDir player) + 90);
		
		if (_canSell) then {
			_id = str(round(random 999999));
		} else {
			_id = "0";
		};
		
		_object setVariable["ObjectID", _id, true];
		_object setVariable["ObjectUID", _id, true];
		_object setVariable["DeployedVehicle", 1, true];
		
		_object addEventHandler["GetIn", {
			"Warning: This vehicle will delete on restart!" call dayz_rollingMessages;
		}];
		
		clearWeaponCargoGlobal _object;
		clearMagazineCargoGlobal _object;
		
		if (_removeAmmo) then {
			_object setVehicleAmmo 0;
		};
	
		player reveal _object;
		
		uiSleep .1;
		player switchMove "";
	
		format["You've deployed a %1!", _displayName] call dayz_rollingMessages;
	} else {
		r_interrupt = false;
		player switchMove "";
		player playActionNow "stop";
		format["Deployment of %1 cancelled.", _displayName] call dayz_rollingMessages;
	};
} else {
    _reasonText call dayz_rollingMessages;
};