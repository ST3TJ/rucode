local utils = {}; do
    utils.ceil = function(v)
        return math.floor(v + 0.5)
    end
end

return utils