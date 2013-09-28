/*
The MIT License (MIT)

Copyright (c) 2013 Téo .L

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.




=======================================
Create a file on your server like this:
cstrike/resource/GameMenu.res

It doesn't matter what you write in there, it's gonna be overwritten anyway.
It just has to be there or the plugin will fail on clients that don't have the file.

Change g_ServerName[] and g_ServerIp[] to the desired values, be sure to write between the " "s.
=======================================
*/

#include <amxmodx>

#define VERSION "0.0.1"

new g_ServerName[] = "YOUR SERVER'S NAME"; //The name of your server (will be displayed in client menu)
new g_ServerIp[] = "IP:PORT"; //Set your server ip

new szText[1200];

public plugin_precache()
	precache_generic("resource/GameMenu.res"); //Path to GameMenu.res

public plugin_init()
{
	register_plugin("GameMenu changer", VERSION , "TEOL");
	
	new size = sizeof(szText) - 1;
	format(szText, size, "^"GameMenu^" { ^"1^" { ^"label^" ^"%s^"", g_ServerName);
	format(szText, size, "%s ^"command^" ^"engine Connect %s^"", szText, g_ServerIp);
	format(szText, size, "%s } ^"2^" { ^"label^" ^"^" ^"command^" ^"^" }", szText);
	format(szText, size, "%s ^"3^" { ^"label^" ^"#GameUI_GameMenu_ResumeGame^"", szText);
	format(szText, size, "%s ^"command^" ^"ResumeGame^" ^"OnlyInGame^" ^"1^" }", szText);
	format(szText, size, "%s ^"4^" { ^"label^" ^"#GameUI_GameMenu_Disconnect^"", szText);
	format(szText, size, "%s ^"command^" ^"Disconnect^" ^"OnlyInGame^" ^"1^"", szText);
	format(szText, size, "%s ^"notsingle^" ^"1^" } ^"5^" { ^"label^" ^"#GameUI_GameMenu_PlayerList^"", szText);
	format(szText, size, "%s ^"command^" ^"OpenPlayerListDialog^" ^"OnlyInGame^" ^"1^" ^"notsingle^" ^"1^"", szText);
	format(szText, size, "%s } ^"9^" { ^"label^" ^"^" ^"command^" ^"^" ^"OnlyInGame^" ^"1^" }", szText);
	format(szText, size, "%s ^"10^" { ^"label^" ^"#GameUI_GameMenu_NewGame^" ^"command^" ^"OpenCreateMultiplayerGameDialog^"", szText);
	format(szText, size, "%s } ^"11^" { ^"label^" ^"#GameUI_GameMenu_FindServers^" ^"command^" ^"OpenServerBrowser^"", szText);
	format(szText, size, "%s } ^"12^" { ^"label^" ^"#GameUI_GameMenu_Options^" ^"command^" ^"OpenOptionsDialog^"", szText);
	format(szText, size, "%s } ^"13^" { ^"label^" ^"#GameUI_GameMenu_Quit^" ^"command^" ^"Quit^" } }", szText);
}

public client_putinserver (id)
	set_task(3.0, "TaskChangeMenu", id);

public TaskChangeMenu(id)
{
	client_cmd(id, "motdfile ^"resource/GameMenu.res^"");
	client_cmd(id, "motd_write %s", szText);
	client_cmd(id, "motdfile ^"motd.txt^"");
}
