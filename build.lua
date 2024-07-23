#!/usr/bin/env lua

--------------
-- Settings --
--------------

-- Set this to true to use a better compression algorithm for the DAC driver.
-- Having this set to false will use an inferior compression algorithm that
-- results in an accurate ROM being produced.
local improved_dac_driver_compression = false

---------------------
-- End of settings --
---------------------

local common = require "build_tools.lua.common"

local compression = improved_dac_driver_compression and "kosinski-optimised" or "kosinski"
if arg == nil then
	arg = {}
end
local mmd_names = {
	"TITLE",
	"GHZ1",
	"GHZ2",
	"GHZ3",
	"MZ1",
	"MZ2",
	"MZ3",
	"SYZ1",
	"SYZ2",
	"SYZ3",
	"LZ1",
	"LZ2",
	"LZ3",
	"SLZ1",
	"SLZ2",
	"SLZ3",
	"SBZ1",
	"SBZ2",
	"SBZ3",
	"FZ",
	"GHZ1DEMO",
	"MZ1DEMO",
	"SYZ1DEMO",
	"SS1DEMO",
	"SS1",
	"SS2",
	"SS3",
	"SS4",
	"SS5",
	"SS6",
	"CONTINUE",
	"ENDING",
	"CREDITS",
}
for k,v in pairs(mmd_names) do
	print("Assembling " .. v .. "...")
	local out_name = "build/" .. v
	local message, abort = common.build_rom("sonic", out_name, "-D MMD=" .. (k - 1), "-p=FF -z=0," .. compression .. ",Size_of_DAC_driver_guess,after", false, "https://github.com/sonicretro/s1disasm")
	os.rename("sonic.lst", out_name .. ".lst")

	if message then
		exit_code = false
	end

	if abort then
		os.exit(exit_code, true)
	end

end

os.exit(exit_code, false)
