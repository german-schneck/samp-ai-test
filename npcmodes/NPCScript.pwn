#include <a_npc>

//------------------------------------------

main()
{
    printf("npctest: main()");
}

//------------------------------------------

public OnNPCModeInit()
{
	printf("npctest: OnNPCModeInit");
}


//------------------------------------------

public OnNPCModeExit()
{
	printf("npctest: OnNPCModeExit");
}

//------------------------------------------

public OnNPCConnect(myplayerid)
{
	printf("npctest: OnNPCConnect(My playerid=%d)", myplayerid);
}

//------------------------------------------

public OnNPCDisconnect(reason[])
{
	printf("npctest: OnNPCDisconnect(reason=%s)", reason);
}

//------------------------------------------

public OnNPCSpawn()
{
    printf("npctest: OnNPCSpawn");
	SetMyPos(2034.4961, 1347.7716, 10.8203);

}

//------------------------------------------

public OnNPCEnterVehicle(vehicleid, seatid)
{
	printf("npctest: OnNPCEnterVehicle(vehicleid=%d,seatid=%d)", vehicleid, seatid);
}

//------------------------------------------

public OnNPCExitVehicle()
{
    printf("npctest: OnNPCExitVehicle");
}

//------------------------------------------

public OnClientMessage(color, text[])
{
    printf("npctest: OnClientMessage(color=%d, text=%s)", color, text);
}

//------------------------------------------

public OnPlayerDeath(playerid)
{
    printf("npctest: OnPlayerDeath(playerid=%d)", playerid);
}

//------------------------------------------

public OnPlayerText(playerid, text[])
{
    printf("npctest: (CHAT)(from=%d, text=%s)", playerid, text);
}

//------------------------------------------

public OnPlayerStreamIn(playerid)
{
    printf("npctest: OnPlayerStreamIn(playerid=%d)", playerid);
}

//------------------------------------------

public OnPlayerStreamOut(playerid)
{
    printf("npctest: OnPlayerStreamOut(playerid=%d)", playerid);
}

//------------------------------------------

public OnVehicleStreamIn(vehicleid)
{
    printf("npctest: OnVehicleStreamIn(vehicleid=%d)", vehicleid);
}

//------------------------------------------

public OnVehicleStreamOut(vehicleid)
{
    printf("npctest: OnVehicleStreamOut(vehicleid=%d)", vehicleid);
}

//------------------------------------------



