private["_object", "_type", "_requiredParts", "_displayName", "_combat", "_playerNear", "_finished", "_inCombat", "_animation"];

_object = _this select 3;
_type = typeOf _object;

#include "config.sqf"

_deployInfo = _type call _getDeployConfig;

_requiredParts = _deployInfo select 0;
_displayName = _deployInfo select 1;
_combat = _deployInfo select 4;
_animation = _deployInfo select 5;

if (player getVariable["inCombat", false] && !_combat) exitWith {
	format["You cannot pack this %1 while you are in combat.", _displayName] call dayz_rollingMessages;
};

_playerNear = _object call dze_isnearest_player;
if (_playerNear) exitWith {
	format["You cannot pack this %1 because there is another player closer to it than you!", _displayName] call dayz_rollingMessages;
};

[player, "repair", 0, false, 10] call dayz_zombieSpeak;
[player, 10, true, (getPosATL player)] spawn player_alertZombies;

_finished = true;
	
if (_animation) then {
	_finished = [_displayName, "pack"] call _playerDoLoop;
};

if (_finished) then {
	{
		private["_add", "_addAmount"];
		_add = _x select 0;
		_addAmount = _x select 1;
	
		if (isClass(configFile >> "CfgWeapons" >> _add)) then {
			private "_i";
			for "_i" from 1 to _addAmount do {
				player addWeapon _add;
			};
		} else {
			private "_i";
			for "_i" from 1 to _addAmount do {
				player addMagazine _add;
			};
		};
	} forEach _requiredParts;
	
	deleteVehicle _object;

	format["You have packed your %1!", _displayName] call dayz_rollingMessages;
} else {
	r_interrupt = false;
	player switchMove "";
	player playActionNow "stop";
	format["Packing of %1 cancelled.", _displayName] call dayz_rollingMessages;
};
