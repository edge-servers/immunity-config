#!/usr/bin/env lua

-- gets the first useful address of the specified interface
-- usage:
--   * immunity-get-address <ifname>
--   * immunity-get-address <network-name>
local os = require('os')
local net = require('immunity.net')
local name = arg[1]
local interface = net.get_interface(name)

if interface then
  print(interface.addr)
else
  os.exit(1)
end
