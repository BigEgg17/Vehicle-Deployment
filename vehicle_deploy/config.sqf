private["_deployInVehicle", "_deployOnLadder", "_deployOnOtherPlots", "_getDeployConfig", "_deployCheckRequirements"];

/***********************/
/**** Configuration ****/
/***********************/

_deployOnOtherPlots = false; // Allow players to deploy vehicles within an enemy players plot area?
_deployInVehicle = false; // Allow players to deploy vehicles while they are in a vehicle?
_deployOnLadder = false; // Allow players to deploy vehicles while they are on a ladder?

// Vehicle array and their part requirements
_getDeployConfig = {
	private["_type", "_requiredParts", "_displayName", "_canSell", "_removeAmmo", "_combat", "_animation", "_result"];
	
	_type = _this;
	
	switch (_type) do {
		case "MMT_Civ":{ // Bike Config
			_requiredParts = [
				["PartGeneric", 1] // Player needs 1 scrap metal to deploy
			];
			_displayName = "Bike"; // Display name of vehicle (in this case bike) - Will show up in text when vehicle is deployed
			_canSell = false; // Can this vehicle be sold at traders?
			_removeAmmo = true; // Remove the ammo from this vehicle?
			_combat = true; // Allow this vehicle to be deployed/packed while the player is in combat?
			_animation = false; // Do an animation while deploying/packing this vehicle?
		};
		case "ATV_US_EP1":{ // ATV Config
			_requiredParts = [
				["PartGeneric", 1],
				["PartEngine", 1], // Player needs 1 scrap metal, 1 engine, and 2 wheels to deploy
				["PartWheel", 2]
			];
			_displayName = "ATV"; // Display name of vehicle (in this case ATV) - Will show up in text when vehicle is deployed
			_canSell = false; // Can this vehicle be sold at traders?
			_removeAmmo = true; // Remove the ammo from this vehicle?
			_combat = false; // Allow this vehicle to be deployed/packed while the player is in combat?
			_animation = true; // Do an animation while deploying/packing this vehicle?
		};
		case "CSJ_GyroC":{ // Mozzie Config
			_requiredParts = [
				["PartGeneric", 1],
				["PartEngine", 1], // Player needs 1 scrap metal, 1 engine, 1 main rotor, and 1 fuel tank to deploy
				["PartVRotor", 1],
				["PartFueltank", 1]
			];
			_displayName = "Mozzie"; // Display name of vehicle (in this case Mozzie) - Will show up in text when vehicle is deployed
			_canSell = false; // Can this vehicle be sold at traders?
			_removeAmmo = true; // Remove the ammo from this vehicle?
			_combat = false; // Allow this vehicle to be deployed/packed while the player is in combat?
			_animation = true; // Do an animation while deploying/packing this vehicle?
		};
	};
	
	_result = [_requiredParts, _displayName, _canSell, _removeAmmo, _combat, _animation];
	_result;
};

/***********************/
/**** End of Config ****/
/***********************/

/* DO NOT TOUCH BELOW THIS LINE */
_deployCheckRequirements = {
	private["_requiredParts", "_displayName", "_deployInCombat", "_result"];
	
	_requiredParts = _this select 0;
	_displayName = _this select 1;
	_deployInCombat = _this select 2;
	
	_result = [true, nil];

	if !(_deployInCombat) then {
		if (player getVariable["inCombat", false]) exitWith {
			_result = [false, format["You cannot deploy a %1 while you are in combat.", _displayName]];
		};
	};
	
	if !(_deployInVehicle) then {
		if (vehicle player != player) exitWith {
			_result = [false, format["You cannot deploy a %1 while inside a vehicle.", _displayName]];
		};
	};
	
	if !(_deployOnLadder) then {
		if ((getNumber(configFile >> "CfgMovesMaleSdr" >> "States" >> (animationState player) >> "onLadder")) == 1) exitWith {
			_result = [false, format["You cannot deploy a %1 while you are on a ladder.", _displayName]];
		};
	};
	
	{
		private["_itemNeeded", "_quantity", "_checkPlayer", "_neededAmount"];
	
		_itemNeeded = _x select 0;
		_quantity = _x select 1;
	
		_checkPlayer = {
			private "_x";
			_x == _itemNeeded
		} count magazines player;
	
		if (_checkPlayer < _quantity) exitWith {
			_neededAmount = (_quantity - _checkPlayer);
			if (isClass(configFile >> "CfgWeapons" >> _itemNeeded)) then {
				_itemNeeded = getText(configFile >> "CfgWeapons" >> _itemNeeded >> "displayName");
			} else {
				_itemNeeded = getText(configFile >> "CfgMagazines" >> _itemNeeded >> "displayName");
			};
			_result = [false, format["You need %1 more %2 to deploy a %3.", _neededAmount, _itemNeeded, _displayName]];
		};
	} forEach _requiredParts;
	
	if !(_deployOnOtherPlots) then {
		private["_nearestPlots", "_nearbyPlots"];
		
		_nearestPlots = player nearEntities["Plastic_Pole_EP1_DZ", DZE_PlotPole select 0];
		_nearbyPlots = count(_nearestPlots);
		
		if (_nearbyPlots > 0) then {
			private["_selectedPlot", "_hasAccess", "_allowed"];
			_selectedPlot = _nearestPlots select 0;
			_hasAccess = [player, _selectedPlot] call FNC_check_access;
			_allowed = ((_hasAccess select 0) || (_hasAccess select 3) || (_hasAccess select 4));
			if !(_allowed) exitWith {
				_result = [false, format["You cannot deploy a %1 within %2 of another player's base.", _displayName, DZE_PlotPole select 0]];
			};
		};
	};

	_result;
};

_playerDoLoop = {
	private["_displayName", "_type", "_animState", "_started", "_finished", "_message", "_isMedic"];
	
	_displayName = _this select 0;
	_type = _this select 1;
	
	player playActionNow "Medic";
	
	r_interrupt = false;
	_animState = animationState player;
	r_doLoop = true;
	_started = false;
	_finished = false;
	
	switch (_type) do {
		case "deploy":{
			_message = format["Deployment of %1 started.", _displayName];
		};
		case "pack":{
			_message = format["Packing of %1 started.", _displayName];
		};
	};
	_message call dayz_rollingMessages;

	while {r_doLoop} do {
		_animState = animationState player;
		_isMedic = ["medic",_animState] call fnc_inString;
		if (_isMedic) then {
			_started = true;
		};
		if (_started and !_isMedic) then {
			r_doLoop = false;
			_finished = true;
		};
		if (r_interrupt) then {
			r_doLoop = false;
		};
		sleep 0.1;
	};
	r_doLoop = false;
	
	_finished;
};
