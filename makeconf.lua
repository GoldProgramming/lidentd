settings = {}
io.stdout:write( "Bindhost (default '*'): " )
local x = io.stdin:read()
if x and x ~= "" then
	settings.bindhost = x
else
	settings.bindhost = "*"
end
io.stdout:write( "Directory:" )
local x = io.stdin:read()
if x and x ~= "" then
	settings.path = x:match( "(.-)/?$" ) .. "/"
else
	settings.path = "./"
end
io.stdout:write( "Port (default '113'): " )
local x = io.stdin:read()
if x and x ~= "" then
	settings.port = tostring( tonumber( x ) or 113 )
else
	settings.port = "113"
end
io.stdout:write( "Enable daemon mode? (default 'false'): " )
local x = io.stdin:read()
if not x or x ~= "true" then
	settings.daemon = "false"
else
	settings.daemon = "true"
end
os.remove( "settings.ini" ) -- delete file incase of corruption
local f = io.open( "settings.ini", "w" )
for k, v in pairs( settings ) do
	print( k, v )
	f:write( tostring( k ) .. "=" .. tostring( v ) .. "\r\n" )
end
