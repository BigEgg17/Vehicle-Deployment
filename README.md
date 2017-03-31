# **Vehicle Deployment**
Compatible with DayZ Epoch 1.0.6.1 +

## **Information:**
* Allows players to deploy a Bike, ATV, or a Mozzie (by default).  

* Compatible with almost all (if not all) vehicles.  

* Required parts can include both magazines and toolbelt items (or weapons in general if needed).  

* Vehicles can be deployed on high buildings, bases, or bridges without issue.  

* The server owner can:
  * Configure what vehicles players can deploy
  * Decide if the player will go through an animation while deploying the vehicle
  * Decide if the player can deploy the vehicle while within someone else's plot area
  * Decide if the player can deploy the vehicle while in combat
  * Decide if the vehicle can be sold at traders
  * Decide if the player can deploy the vehicle while in a vehicle
  * Decide if the vehicle should have it's ammo removed when deployed
  * Decide if the player can deploy the vehicle on a ladder
  * Decide what parts each vehicle needs to be deployed
  * Decide what the display name of the vehicle will be on all messages that appear during the process

## **Installation:**  
[>> Download Files <<](https://github.com/BigEgg17/Vehicle-Deployment/archive/master.zip "Download Files")  

1. Drag the vehicle_deploy folder into the root of your mission file.  

2. File Transfers:    

* If you don't already have a custom compiles.sqf:  
   
  * Create a new file called compiles.sqf and save it to a folder in your mission root called "custom".  
  
  * In your init.sqf find:  

   ```sqf
   call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\compiles.sqf";
   ```  
   
  * Under it add:
   ```sqf
   call compile preprocessFileLineNumbers "custom\compiles.sqf";
   ```  
   
  * In compiles.sqf, copy and paste the following (these two files will be created in the instructions below):
   ```sqf
   if (isDedicated) then {
       fnc_usec_selfactions = compile preprocessFileLineNumbers "custom\fn_selfActions.sqf";
       player_selectSlot = compile preprocessFileLineNumbers "custom\ui_selectSlot.sqf";
   };
   ```  
   
* If you don't already have a custom variables.sqf:
  * Create a new file called variables.sqf and save it to a folder in your mission root called "custom".  
  
  * In your init.sqf find:
  ```sqf
  call compile preprocessFileLineNumbers "\z\addons\dayz_code\init\variables.sqf";
  ```  
  
  * Under it add:
  ```sqf
  call compile preprocessFileLineNumbers "custom\variables.sqf";
  ```
  
  * In variables.sqf, copy and paste the following:
  ```sqf
  dayz_resetSelfActions = {
	s_player_equip_carry = -1;
	s_player_dragbody = -1;
	s_player_fire = -1;
	s_player_cook = -1;
	s_player_boil = -1;
	s_player_fireout = -1;
	s_player_packtent = -1;
	s_player_packtentinfected = -1;
	s_player_fillwater = -1;
	s_player_fillwater2 = -1;
	s_player_fillfuel = -1;
	s_player_grabflare = -1;
	s_player_removeflare = -1;
	s_player_painkiller = -1;
	s_player_studybody = -1;
	s_build_Sandbag1_DZ = -1;
	s_build_Hedgehog_DZ = -1;
	s_build_Wire_cat1 = -1;
	s_player_deleteBuild = -1;
	s_player_flipveh = -1;
	s_player_stats = -1;
	s_player_sleep = -1;
	s_player_fillfuel210 = -1;
	s_player_fillfuel20 = -1;
	s_player_fillfuel5 = -1;
	s_player_siphonfuel = -1;
	s_player_repair_crtl = -1;
	s_player_fishing = -1;
	s_player_fishing_veh = -1;
	s_player_gather = -1;
	s_player_debugCheck = -1;
	s_player_destroytent = -1;
	s_player_attach_bomb = -1;
	s_player_upgradestorage = -1;
	s_player_Drinkfromhands = -1;
	/*s_player_lockhouse = -1; //Vanilla base building currently not used in Epoch
	s_player_unlockhouse = -1;
	s_player_openGate = -1;
	s_player_CloseGate = -1;
	s_player_breakinhouse = -1;
	s_player_setCode = -1;
	s_player_BuildUnLock = -1;
	s_player_BuildLock = -1;*/
	
	// EPOCH ADDITIONS
	s_player_packvault = -1;
	s_player_lockvault = -1;
	s_player_unlockvault = -1;
	s_player_attack = -1;
	s_player_callzombies = -1;
	s_player_showname = -1;
	s_player_pzombiesattack = -1;
	s_player_pzombiesvision = -1;
	s_player_pzombiesfeed = -1;
	s_player_tamedog = -1;
	s_player_parts_crtl = -1;
	s_player_movedog = -1;
	s_player_speeddog = -1;
	s_player_calldog = -1;
	s_player_feeddog = -1;
	s_player_waterdog = -1;
	s_player_staydog = -1;
	s_player_trackdog = -1;
	s_player_barkdog = -1;
	s_player_warndog = -1;
	s_player_followdog = -1;
	s_player_information = -1;	
	s_player_fuelauto = -1;
	s_player_fuelauto2 = -1;
	s_player_fillgen = -1;
	s_player_upgrade_build = -1;
	s_player_maint_build = -1;
	s_player_downgrade_build = -1;
	s_player_towing = -1;
	s_halo_action = -1;
	s_player_SurrenderedGear = -1;
	s_player_maintain_area = -1;
	s_player_maintain_area_force = -1;
	s_player_maintain_area_preview = -1;
	s_player_heli_lift = -1;
	s_player_heli_detach = -1;
	s_player_lockUnlock_crtl = -1;
	s_player_lockUnlockInside_ctrl = -1;
	s_player_toggleSnap = -1;
	s_player_toggleSnapSelect = -1;
	s_player_toggleSnapSelectPoint = [];
	snapActions = -1;
	s_player_plot_boundary = -1;
	s_player_plotManagement = -1;
	s_player_toggleDegree = -1;
	s_player_toggleDegrees=[];
	degreeActions = -1;
	s_player_toggleVector = -1;
	s_player_toggleVectors=[];
	vectorActions = -1;
	s_player_manageDoor = -1;
  };
  call dayz_resetSelfActions;
  ```
* If you don't have a custom fn_selfActions.sqf:
  * Copy fn_selfActions.sqf to your custom folder from dayz_code\compile  
* If you don't have a custom ui_selectSlot.sqf:
  * Copy ui_selectSlot.sqf to your custom folder from dayz_code\compile  

3. Variables.sqf:  

* Find:
  ```sqf
  s_player_manageDoor = -1;
  ```  

* Below it add:
  ```sqf
  // Vehicle Deployment
  s_player_packvehicle = -1;
  ```  
  
* Add at the bottom:
```sqf
Deployables = ["MMT_Civ", "ATV_US_EP1", "CSJ_GyroC"];

if (isServer) then {
	DZE_safeVehicle = DZE_safeVehicle + Deployables;
};
```  

4. fn_selfActions.sqf:  

* Find:
```sqf
if (_isGenerator) then {
    if (s_player_fillgen < 0) then {
        if (_cursorTarget getVariable["GeneratorRunning", false]) then {
            s_player_fillgen = player addAction[localize "STR_EPOCH_ACTIONS_GENERATOR1", "\z\addons\dayz_code\actions\stopGenerator.sqf", _cursorTarget, 0, false, true];
        } else {
            if (_cursorTarget getVariable["GeneratorFilled", false]) then {
                s_player_fillgen = player addAction[localize "STR_EPOCH_ACTIONS_GENERATOR2", "\z\addons\dayz_code\actions\fill_startGenerator.sqf", _cursorTarget, 0, false, true];
            } else {
                if (_hasFuel20 or _hasFuel5 or _hasBarrel) then {
                    s_player_fillgen = player addAction[localize "STR_EPOCH_ACTIONS_GENERATOR3", "\z\addons\dayz_code\actions\fill_startGenerator.sqf", _cursorTarget, 0, false, true];
                };
            };
        };
    };
} else {
    player removeAction s_player_fillgen;
    s_player_fillgen = -1;
};
```  

* Below it add:
```sqf
if ((speed player <= 1) && (_cursorTarget getVariable["DeployedVehicle", 0] == 1) && ((count(crew _cursorTarget)) == 0) && (damage _cursorTarget < 1) && _hasToolbox) then {
	if (s_player_packvehicle < 0) then {
		s_player_packvehicle = player addAction["Pack Vehicle", "vehicle_deploy\pack.sqf", _cursorTarget, 0, false, true, "", ""];
	};
} else {
	player removeAction s_player_packvehicle;
	s_player_packvehicle = -1;
};
```  

* Find:
```sqf
player removeAction s_player_fuelauto2;
s_player_fuelauto2 = -1;
player removeAction s_player_manageDoor;
s_player_manageDoor = -1;
```  

* Below it add:
```sqf
player removeAction s_player_packvehicle;
s_player_packvehicle = -1;
```  

5. ui_selectSlot.sqf:  

* Find:
```sqf
_pos set [3,_height];
```  

* Above it add:
```sqf
// Extra Right Click Options by Maca134
_erc_cfgActions = (missionConfigFile >> "ExtraRc" >> _item);
_erc_numActions = (count _erc_cfgActions);
if (isClass _erc_cfgActions) then {
	for "_j" from 0 to (_erc_numActions - 1) do {
		_menu =  _parent displayCtrl (1600 + _j + _numActions);
		_menu ctrlShow true;
		_config =  (_erc_cfgActions select _j);
		_text =  getText (_config >> "text");
		_script =  getText (_config >> "script");
		_height = _height + (0.025 * safezoneH);
		uiNamespace setVariable ['uiControl', _control];
		_menu ctrlSetText _text;
		_menu ctrlSetEventHandler ["ButtonClick",_script];
	};
};
```  

6. description.ext:  

* At the bottom add:
```hpp
#include "vehicle_deploy\extra_rc.hpp";
```  

## Legal:
This work is licensed under the DAYZ MOD LICENSE SHARE ALIKE (DML-SA). The full license is here:
https://www.bistudio.com/community/licenses/dayz-mod-license-share-alike
