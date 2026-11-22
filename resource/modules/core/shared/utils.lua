lib.locale()

function TrimLicensePlate(licensePlate)
    if type(licensePlate) ~= 'string' then return '' end
    return (licensePlate:gsub('^%s+', ''):gsub('%s+$', ''))
end

function MakeRentalPlate(platePrefix)
    local prefix = TrimLicensePlate(platePrefix)
    if prefix == '' then prefix = 'RN' end
    prefix = prefix:sub(1, 7)

    local digitCount = 8 - #prefix
    local maxNumber = (10 ^ digitCount) - 1
    return ('%s%0' .. digitCount .. 'd'):format(prefix, math.random(0, maxNumber))
end
