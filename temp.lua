--- Temporator code owner
--- https://github.com/HaxersAlwaysWin/FiveM-Temporator/blob/master/client.lua

MAX_INCREASE = 1.5 -- Maximum increase in temperature between time changes
MIN_INCREASE = 0.2 -- Minimum increase in temperature between time changes
RAND_FLUC = 0.2 -- How much the temperature will fluctuate when equal to the Min or Max temperature
START_INCREASE_HR = 4 -- When the temperature will start increasing based on the time of day (4 am is default)
STOP_INCREASE_HR = 16 -- When the temperature will stop increasing based on the time of day (4 pm is default)

MonthData = {
	{36, 20}, -- January
	{41, 24}, -- February
	{53, 34}, -- March
	{65, 43}, -- April
	{75, 54}, -- May
	{82, 61}, -- June
	{86, 66}, -- July
	{85, 64}, -- August
	{78, 58}, -- September
	{66, 46}, -- October
	{53, 37}, -- November
	{43, 28}, -- December
}


AvailableWeatherTypes = {
    'EXTRASUNNY', 
    'CLEAR', 
    'NEUTRAL', 
    'SMOG', 
    'FOGGY', 
    'OVERCAST', 
    'CLOUDS', 
    'CLEARING', 
    'RAIN', 
    'THUNDER', 
    'SNOW', 
    'BLIZZARD', 
    'SNOWLIGHT', 
    'XMAS', 
    'HALLOWEEN',
}

function getTemp()
    local init_hr = GetClockHours()
    local weather = Citizen.InvokeNative(0x564B884A05EC45A3)
    local init_w = getWeatherStringFromHash(weather)
    local init_m = GetClockMonth()
    temp = calcTemp( init_w, init_m, init_hr )
    if cfg_meteo.ConvertFahrenheitToCelsius == true then 
        return FtoC(temp)
    else 
        return temp 
    end
end

function calcTemp( weth, mth, hr )
	if mth == 0 then
	   mth = 1
	end
	local Max = MonthData[mth][1]
	local Min = MonthData[mth][2]
	local AbsMax = 32
	local AbsMin = -20
	local curTemp = randf(AbsMin, AbsMax)
	
	if weth == 'SNOW' or weth == 'BLIZZARD' or weth == 'SNOWLIGHT' or weth == 'XMAS' then
		AbsMax = 32  
		AbsMin = -20
	elseif weth == 'EXTRASUNNY' then
		AbsMax = Max + 20
		AbsMin = Min + 20
	elseif weth == 'SMOG' then
		AbsMax = Max + 10
		AbsMin = Min + 10
	elseif weth == 'FOGGY' or weth == 'CLOUDS' or weth == 'THUNDER' or weth == 'HALLOWEEN' then
		AbsMax = Max - 10
		AbsMin = Min - 10
	else
		AbsMax = Max
		AbsMin = Min
	end
	
	curTemp = randf(AbsMin, AbsMax)
	
	if (hr >= START_INCREASE_HR and hr < STOP_INCREASE_HR) then
		if curTemp >= AbsMax then
			curTemp = AbsMax + randf(-RAND_FLUC, RAND_FLUC)
		else
			curTemp = curTemp + randf(MIN_INCREASE, MAX_INCREASE)
		end
	else
		if curTemp <= AbsMin then
			curTemp = AbsMin + randf(-RAND_FLUC, RAND_FLUC)
		else
			curTemp = curTemp - randf(MIN_INCREASE, MAX_INCREASE)
		end
	end
	return curTemp
end


function getWeatherStringFromHash( hash )
	local w = '?'
	for i = 1, # AvailableWeatherTypes, 1 do
		if hash == GetHashKey(AvailableWeatherTypes[i]) then
			w = AvailableWeatherTypes[i]
		end
	end
	return w
end


function genSeed()
	return (GetClockYear() + GetClockMonth() + GetClockDayOfWeek())
end

function randf(low, high)
	math.randomseed(GetClockDayOfMonth() + GetClockYear() + GetClockMonth() + GetClockHours())
    return low	 + math.random()  * (high - low);
end

function FtoC( f )
	return ((f - 32) * (5 / 9))
end