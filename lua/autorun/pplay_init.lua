---------------------
--  CREATE TABLES  --
---------------------

sv_PPlay = {}
cl_PPlay = {}



-------------------------
--  LOAD CLIENT FILES  --
-------------------------

AddCSLuaFile()
AddCSLuaFile("patchplay/client/player.lua")
AddCSLuaFile("patchplay/client/panel_functions.lua")
AddCSLuaFile("patchplay/client/panel_main.lua")
AddCSLuaFile("patchplay/client/panel_server.lua")
AddCSLuaFile("patchplay/client/sql.lua")
AddCSLuaFile("patchplay/client/panel_private.lua")
AddCSLuaFile("patchplay/client/hud.lua")



--------------------------------
--  LOAD SERVER/CLIENT FILES  --
--------------------------------

if SERVER then

	-- INCLUDE FILES
	include( "patchplay/server/sender.lua" )
	include( "patchplay/server/config.lua" )
	include( "patchplay/server/settings.lua" )
	

else

	include( "patchplay/client/player.lua" )
	include( "patchplay/client/panel_functions.lua" )
	include( "patchplay/client/panel_main.lua" )
	include( "patchplay/client/panel_server.lua" )
	include( "patchplay/client/sql.lua" )
	include( "patchplay/client/panel_private.lua" )
	include( "patchplay/client/hud.lua" )
	
end
