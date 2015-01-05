settings = ...
assert( ( settings.bindhost and settings.port and settings.path ), "Missing settings - run 'start.lua makeconf'" )
socket = require( "socket" )
server = socket.bind( settings.bindhost, settings.port ) -- should be tonumber()ed
while true do
	local cli = server:accept()
	local f = io.open( settings.path .. ".ident" )
	local ident = f:read() or "lidentd"
	pcall( f.close, f )
	local l = cli:receive()
	if l then
		cli:send( l:gsub( " ", "" ) .. ":USERID:Lua5.2:" .. ident .. "\r\n" )
	end
	pcall( cli.close, cli )
end
