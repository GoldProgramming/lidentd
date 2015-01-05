posix = require( "posix" )
settings = ...
assert( ( settings.bindhost and settings.port and settings.path ), "Missing settings - run 'start.lua makeconf'" )
local pid = posix.fork()
if pid ~= 0 then -- parent gets child PID
	local f = io.open( settings.path .. ".lockfile", "w" )
	if f then
		f:write( tostring( pid ) .. "\r\n" )
		pcall( f.close, f )
	else
		error( "Unable to open lockfile, aborting" )
	end
	os.exit()
end
socket = require( "socket" )
server = socket.bind( settings.bindhost, settings.port ) -- should be tonumber()ed
posix.signal( posix.SIGTERM, function()
	pcall( server.close, server )
	os.remove( path .. ".lockfile" )
	os.exit()
end)
posix.signal( posix.SIGUSR1, function()
	pcall( server.close, server ) -- stop just in case
	server = socket.bind( settings.bindhost, settings.port ) -- reloads socket
end)
server:settimeout( 0.1 )
while true do
	local cli = server:accept()
	if cli then
		local f = io.open( settings.path .. ".ident" )
		local ident = f:read() or "lidentd"
		pcall( f.close, f )
		local l = cli:receive()
		if l then
			cli:send( l:gsub( " ", "" ) .. ":USERID:Lua5.2:" .. ident .. "\r\n" )
		end
		pcall( cli.close, cli )
	end
end
