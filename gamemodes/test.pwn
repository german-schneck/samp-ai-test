/**
	   Los Santos RolePlay
	=========================
	@author German D. Schneck
	=========================
 */

#include <a_samp>
#include <a_http>
#include <json>

// Definitions
#define BOT_NAME "Yulliana"
#define DISTANCE_TO_END_CONVERSATION 10.0
#define MAX_CONVERSATION_LENGTH 512

// Vars
new npcID;  // Almacenar el ID del bot una vez que est� conectado
new bool:IsInConversation[100];

// Forwards
forward MyHttpResponse(index, response_code, data[]);
forward GenerateResponse(response[]);

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

/**
 * Initializes game mode settings and configurations.
 * 
 * @return  1, to indicate successful execution.
 * 
 * Sets the game mode text, adds a player class, and connects an NPC named "Yulliana" using a specified script.
 */
public OnGameModeInit()
{
	SetGameModeText("LS:RP Español");

	AddPlayerClass(223,2033.9233,1351.9437,10.8203,182.3717,0,0,0,0,0,0);
    npcID = ConnectNPC("Yulliana", "NPCScript");

	return 1;
}


/**
 * Handles when a player requests to spawn in the game world after selecting a class.
 * 
 * @param playerid The ID of the player making the request.
 * @return         1, to indicate successful execution.
 * 
 * For NPCs, sets specific coordinates, skin, and angle.
 * For real players, sends a welcome message and sets a different set of coordinates, skin, and angle.
 */
public OnPlayerRequestClass(playerid)
{
    if(IsPlayerNPC(playerid))
    {
        SetPlayerSkin(playerid, 172);
        SetPlayerFacingAngle(playerid, 359.6734);
    }
    else
    {
        SendClientMessage(playerid, 0xFFFFFF, "Bienvenido!");
  		SetPlayerPos(playerid, 2033.9233,1351.9437,10.8203);
        SetPlayerSkin(playerid, 223);
        SetPlayerFacingAngle(playerid, 182.3717);
    }
    return 1;
}

/**
 * Handles player connections to the server.
 * 
 * @param playerid The ID of the player connecting.
 * @return         1, to indicate successful execution.
 * 
 * For NPCs, this function creates and attaches a 3D label named "Yulliana".
 * For players, it ensures they are not marked as in conversation upon joining.
 */
public OnPlayerConnect(playerid)
{
	if(IsPlayerNPC(playerid)) {
		new Text3D:label = Create3DTextLabel("Yulliana", 0xFFFFFFFF, 30.0, 20.0, 20.0, 20.0, 0);
	    Attach3DTextLabelToPlayer(label, playerid, 0.0, 0.0, 0.7);
	} else {
		IsInConversation[playerid] = false;
	}

	return 1;
}

/**
 * Handles player disconnections from the server.
 * 
 * @param playerid The ID of the player disconnecting.
 * @param reason   The reason for the player's disconnection.
 * @return         1, to indicate successful execution.
 * 
 * This function ensures that if a player disconnects, they are 
 * removed from any ongoing conversations.
 */
public OnPlayerDisconnect(playerid, reason)
{		
	IsInConversation[playerid] = false;
	return 1;
}

/**
 * Handles the text entered by a player.
 * 
 * @param playerid The ID of the player entering the text.
 * @param text[]   The content of the text being entered.
 * @return         0 to block the message from being displayed to other players.
 */
public OnPlayerText(playerid, text[])
{		
	DisplayMessageNearPlayer(playerid, text);
	
	if(IsPlayerInRangeOfPlayer(playerid, npcID, 10.0)) 
	{
		if(IsInConversation[playerid] || strfind(text, BOT_NAME) != -1)
		{
			SendMessageToAPI(playerid, text);

			if(strfind(text, BOT_NAME) != -1)
			{
				IsInConversation[playerid] = true;
			}

			return 0;
		}
	}
    return 0;
}


/**
 * Handles the regular updates for a player.
 * 
 * @param playerid The ID of the player being updated.
 * @return         1, since returning 0 has no specific effect in this callback.
 * 
 * This function checks if a player in conversation moves out of range 
 * of an NPC and ends the conversation if they do.
 */
public OnPlayerUpdate(playerid)
{
	if(IsInConversation[playerid])
    {
        if(!IsPlayerInRangeOfPlayer(playerid, npcID, DISTANCE_TO_END_CONVERSATION))
        {
            IsInConversation[playerid] = false;
            SendClientMessage(playerid, 0xFFFFFFAA, "Conversación terminada debido a la distancia.");
        }
    }
	return 1;
}


/**
 * Handles the HTTP response from an API request.
 * 
 * @param index         Typically the playerid that initiated the request.
 * @param response_code The HTTP response code from the API.
 * @param data[]        The content or data of the response.
 */
public MyHttpResponse(index, response_code, data[])
{
    // In this callback "index" would normally be called "playerid" ( if you didn't get it already:) )
    if (response_code == 200) //Did the request succeed?
    {
		GenerateResponse(data);
    }
    else
    {
		SendClientMessageToAll(0xFFFFFFFF, "Lo siento, ando algo cansada como para contestar eso.");
    }
}

/**
 * Calculates the distance between two 3D coordinates.
 * 
 * @param x1, y1, z1  The 3D coordinates of the first point.
 * @param x2, y2, z2  The 3D coordinates of the second point.
 * @return            The distance between the two points.
 */
stock Float:GetDistanceBetweenCoords3D(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2) + (z1 - z2) * (z1 - z2));
}

/**
 * Checks if one player is within a certain distance of another player.
 * 
 * @param playerid1  ID of the first player.
 * @param playerid2  ID of the second player.
 * @param distance   Maximum distance to check.
 * @return           1 if the players are within the distance, 0 otherwise.
 */
stock IsPlayerInRangeOfPlayer(playerid1, playerid2, Float:distance)
{
    new Float:x1, Float:y1, Float:z1;
    new Float:x2, Float:y2, Float:z2;

    GetPlayerPos(playerid1, x1, y1, z1);
    GetPlayerPos(playerid2, x2, y2, z2);

    if(GetDistanceBetweenCoords3D(x1, y1, z1, x2, y2, z2) <= distance)
        return 1;
    return 0;
}


/**
 * Sends a message to the API endpoint.
 * 
 * @param playerid ID of the player sending the message.
 * @param text[]   Message to be sent.
 */
stock SendMessageToAPI(playerid, text[])
{
	new postData[128];
	format(postData, sizeof(postData), "message=%s", text); 
	HTTP(playerid, HTTP_POST, "127.0.0.1:3000/chat", postData, "MyHttpResponse");
}

/**
 * Broadcasts the chat bot's response to all players.
 * 
 * @param response[]  The raw JSON response from the chat bot.
 * @return 0 - Indicates successful execution.
 * 
 * Extracts the "response" key from the JSON and sends it prefixed by "Yulliana:".
 */
public GenerateResponse(response[]) 
{
    new Node:node;
    new ret;


	ret = JSON_Parse(response, node);

	printf("%s", response);

    new text[MAX_CONVERSATION_LENGTH];
    ret = JSON_GetString(node, "response", text);

	new buffer[MAX_CONVERSATION_LENGTH];
	format(buffer, sizeof(buffer), "Yulliana: %s", text);
    SendClientMessageToAll(0xFFFFFFFF, buffer);
    return 0;
}

/**
 * Sends a message to all players within a certain distance of given coordinates.
 * 
 * @param x          X-coordinate.
 * @param y          Y-coordinate.
 * @param z          Z-coordinate.
 * @param color      Color of the message.
 * @param message[]  The message to be sent.
 */
stock SendClientMessageNearby(Float:x, Float:y, Float:z, color, const message[])
{
    // Iterate through all possible players.
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        // Check if the player is connected and is within the specified distance from the given coordinates.
        if(IsPlayerConnected(i) && IsPlayerInRangeOfPoint(i, DISTANCE_TO_END_CONVERSATION, x, y, z))
        {
            // Send the message to the player.
            SendClientMessage(i, color, message);
        }
    }
}

/**
 * Sends a message to all players near a specified player.
 * 
 * @param playerid   ID of the player whose nearby players should receive the message.
 * @param color      Color of the message.
 * @param message[]  The message to be sent.
 */
stock SendClientMessageNearPlayer(playerid, color, const message[])
{
    // Retrieve the player's current position.
    new Float:playerX, Float:playerY, Float:playerZ;
    GetPlayerPos(playerid, playerX, playerY, playerZ);

    // Send the message to players near the retrieved position.
    SendClientMessageNearby(playerX, playerY, playerZ, color, message);
}

/**
 * Displays a message prefixed with the player's name to nearby players.
 * 
 * @param playerid   ID of the player sending the message.
 * @param text[]     The message content.
 */
stock DisplayMessageNearPlayer(playerid, text[])
{
    // Get the name of the player based on their ID.
	new message[128], playerName[MAX_PLAYER_NAME];
	GetPlayerName(playerid, playerName, sizeof(playerName));

    // Format the message to include the player's name followed by the content.
	format(message, sizeof(message), "%s: %s", playerName, text); 

    // Use a helper function to send the message to all nearby players.
	SendClientMessageNearPlayer(playerid, 0xFFFFFFFF, message);
}