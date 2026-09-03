-- NumberFormatter.lua (ReplicatedStorage — ModuleScript)
-- Formate les gros nombres en versions abrégées lisibles :
-- 999 → "999" / 1000 → "1K" / 1M / 1B / 1T / 1Q / 1Qi / 1S

local NumberFormatter = {}

local SUFFIXES = {"", "K", "M", "B", "T", "Q", "Qi", "S"}

function NumberFormatter.format(n)
	if n < 1000 then
		return tostring(n)
	end

	local index = math.floor(math.log10(n) / 3)
	if index > #SUFFIXES - 1 then
		index = #SUFFIXES - 1
	end

	local formatted = n / (1000 ^ index)

	if formatted == math.floor(formatted) then
		return string.format("%d%s", formatted, SUFFIXES[index + 1])
	else
		return string.format("%.1f%s", formatted, SUFFIXES[index + 1])
	end
end

return NumberFormatter
