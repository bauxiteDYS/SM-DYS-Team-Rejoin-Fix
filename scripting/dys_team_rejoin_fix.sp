#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>
#include <dhooks>

#define DEBUG false

public Plugin myinfo = {
	name = "Dys Team rejoin fix",
	description = "Removes the cooldown when rejoining a team",
	author = "bauxite",
	version = "0.1.0",
	url = "",
};

public void OnPluginStart()
{
	Handle gd = LoadGameConfigFile("dystopia/team");
	if (gd == INVALID_HANDLE)
	{
		SetFailState("Failed to load GameData");
	}
	DynamicDetour dd = DynamicDetour.FromConf(gd, "Fn_PreventTeamRejoin");
	if (!dd)
	{
		SetFailState("Failed to create dynamic detour");
	}
	if (!dd.Enable(Hook_Pre, TeamReJoin))
	{
		SetFailState("Failed to detour");
	}
	delete dd;
	CloseHandle(gd);
}

MRESReturn TeamReJoin(int pThis, DHookReturn hReturn, DHookParam hParams)
{
	#if DEBUG
	PrintToChatAll("pThis %d", pThis);
	PrintToChatAll("int %d", hParams.Get(1));
	#endif
	
	DHookSetReturn(hReturn, 0);
	
	return MRES_Override;
}
