-- NumberFormatter.lua (ReplicatedStorage — ModuleScript)
-- Formate les grands nombres en suffixes lisibles : 1000 → 1K, 1M, 1B, 1T, etc.

local NumberFormatter = {}

-- Suffixes progressifs
local SUFFIXES = {
    "",    -- 10^0  = pas de suffixe
    "K",   -- 10^3  = mille
    "M",   -- 10^6  = million
    "B",   -- 10^9  = milliard (billion en anglais)
    "T",   -- 10^12 = trillion
    "Q",   -- 10^15 = quadrillion
    "Qi",  -- 10^18 = quintillion
    "S",   -- 10^21 = sextillion
}

-- Fonction principale de formatage
function NumberFormatter.format(number)
    -- Sécurité : gérer les nombres négatifs (rare mais possible)
    if number < 0 then
        return "-" .. NumberFormatter.format(-number)
    end
    
    -- Sécurité : nombres nuls ou petits (< 1000)
    if number < 1000 then
        return tostring(math.floor(number))
    end
    
    -- Calcul de l'index du suffixe (basé sur log10)
    local suffixIndex = math.floor(math.log10(number) / 3) + 1
    
    -- Limiter à la taille du tableau (sinon crash au-delà de 10^21)
    if suffixIndex > #SUFFIXES then
        suffixIndex = #SUFFIXES
    end
    
    -- Calcul du nombre affiché (divisé par la puissance de 1000)
    local divisor = 10 ^ ((suffixIndex - 1) * 3)
    local displayNumber = number / divisor
    
    -- Formatage : 1 décimale si < 100, sinon 0 décimale
    local formatted
    if displayNumber < 10 then
        formatted = string.format("%.1f", displayNumber)
    elseif displayNumber < 100 then
        formatted = string.format("%.1f", displayNumber)
    else
        formatted = string.format("%d", math.floor(displayNumber))
    end
    
    -- Retirer le ".0" inutile (ex: "10.0K" → "10K")
    formatted = formatted:gsub("%.0$", "")
    
    return formatted .. SUFFIXES[suffixIndex]
end

return NumberFormatter
