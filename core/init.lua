Bridge = exports.community_bridge:Bridge()

function locale(message, ...)
    return Bridge.Language.Locale(message, ...)
end

if not IsDuplicityVersion() then
    RegisterNetEvent("community_bridge:Client:OnPlayerUnload")

    RegisterNetEvent("community_bridge:Client:OnPlayerLoaded")
end