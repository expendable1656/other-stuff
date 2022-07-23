-- To initialize module, call Module.SecondOrderDynamics(f, z, r)
-- To update, call Module.Update(Alpha, Target, From)
-- C# to Lua convert from https://youtu.be/KPoeNZZ6H4s?t=852

local Module = {}
local xp, y, yd, _w, _z, _d, k1, k2, k3 = 0, 0, 0, 0, 0, 0, 0, 0, 0

local PI = math.pi
function Module.SecondOrderDynamics(f, z, r)
    local x0 = 0
    _w = 2 * PI * f
    _z = z
    _d = _d * math.sqrt(math.abs(z*z - 1))
    k1 = z / (PI * f)
    k2 = 1 / (_w * _w)
    k3 = r * z / _w

    xp = x0
    y = x0
    yd = 0
end

function Module.Update(T, x, xd)
    if not xd then
        xd = (x - xp) / T
        xp = x
    end
    local k1_stable, k2_stable
    if _w * T < _z then
        k1_stable = k1
        k2_stable = math.max(k2, T*T/2 + T*k1/2, T*k1)
    else
        local t1 = math.exp(-_z * _w * T)
        local alpha = 2 * t1 * (_z <= 1 and math.cos(T * _d) or math.cosh(T * _d))
        local beta = t1 * t1
        local t2 = T / (1 + beta - alpha)
        k1_stable = (1 - beta) * t2
        k2_stable = T * t2
    end
    y = y + T * yd
    yd = yd + T * (x + k3*xd - y - k1*yd) / k2_stable
    return y
end

return Module
