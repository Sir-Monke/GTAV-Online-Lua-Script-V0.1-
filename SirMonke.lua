local hashExplode = "explodeHash"
local hashExplodeLoop = "explodeloopHash"
local hashDildo = "dildoHash"
local hashMonke = "monkeHash"
local hashSound = "soundHash"
local hashQuickClose = "quickCloseHash"
local hashVFX = "vfxHash"

local toggle = false
local objectLimit = 100;

local dildo_spawned = {}
local peds_spawned = {}

local objectHashes = {
[0.0] = "prop_cs_dildo_01",
[1.0] = "prop_ld_toilet_01",
[2.0] = "prop_toilet_roll_01",
[3.0] = "prop_armour_pickup",
[4.0] = "prop_gascyl_01a",
[5.0] = "prop_gnome1"
}

function quickClose()
    os.exit(0)
end

function get_coords( coords )
    local t={}
        for str in string.gmatch( coords, "([^%s]+)" ) do
            t [#t + 1] = ""..str
        end
        t[1] = string.gsub(t[1],',' ,'')
        t[2] = string.gsub(t[2],',' ,'')
        t[3] = string.gsub(t[3],',' ,'')
    return t
end
function flingPlayers ()
    local playerToExplode = player.get_id()
    local coords = {}
    local coords = get_coords( lobby.get_player_coords_str(playerToExplode))
    rage.fire.add_explosion(coords[1], coords[2], coords[3], 4, 10, false, true, 0, true)
    notify.above_map("Player Exploded")
end
function flingPlayersLoop ()
    if toggle == false then
        toggle = true
        notify.above_map("Fling ~g~On")
    else
        toggle = false
        notify.above_map("Fling ~r~Off")
    end
    while (toggle) do
        local playerToExplode = player.get_id()
        local coords = {}
        local coords = get_coords( lobby.get_player_coords_str(playerToExplode))
        rage.fire.add_explosion(coords[1], coords[2], coords[3], 4, 10, false, true, 0, true)
        system.wait(250)
    end
end
function dildoRain()

end
function spawnEnt()
    player_2 = player.get_id()
    ped_hash_2 = rage.gameplay.get_hash_key("a_m_y_acult_01")
    rage.streaming.request_model(ped_hash_2)
    coords_2 = lobby.get_player_coords(player_2)
    system.wait(100)
    if rage.streaming.has_model_loaded(ped_hash_2) then
        summonPed = rage.ped.create_ped(28, ped_hash_2, coords_2.x,coords_2.y,coords_2.z,90, true, true)
        peds_spawned[#peds_spawned+1] = summonPed
    else
        notify.above_map("~r~Failed To Load Ped Hash")
    end
end
function overlayDraw ()
    localPlayer = player.get_id()
    textDrawX = menu.get_option_value("overlayTextX")
    textDrawY = menu.get_option_value("overlayTextY")
    textDrawSize = menu.get_option_value("overlayTextSize")
    getHost = lobby.get_host()
    hostName = lobby.get_player_name(getHost)

    lobbyHost = "~b~Lobby Host : " .. hostName
    playerCount = "~b~Player Count : " .. lobby.get_active_players()
    render.draw_text("playerCountHash", true, playerCount, textDrawX, textDrawY, textDrawSize, { 255, 255, 255, 255 }, 0)
    render.draw_text("lobbyHostHash", true, lobbyHost, textDrawX, textDrawY + 50, textDrawSize, { 255, 255, 255, 255 }, 0)
end

--//////////////////////////////
--//Menu                      //
--//////////////////////////////
parent = menu.add_parent("Monke Menu")

--//////////////////////////////
--//Troll                     //
--//////////////////////////////
troll = menu.add_child("Troll", parent)
menu.add_delimiter("Object Rain", troll)
menu.add_option_toggle("Object Rain", "objectRainEnabled", troll)
menu.add_option_value_str("Rain Object", "objectRainSelect", 0, troll, {
    "Dildo",
    "Toilet Paper",
    "Armor",
    "Gas Cylinder",
    "Gnome"
}, objectRain)

menu.add_delimiter("Troll", troll)
menu.add_option("Fling Everyone",hashExplode, troll, flingPlayers)
menu.add_option("Fling Loop",hashExplodeLoop, troll, flingPlayersLoop)
menu.add_option("Spawn Ape",hashMonke, troll, spawnEnt)
menu.add_delimiter("Troll Options", troll)

--//////////////////////////////
--//Overlay                   //
--//////////////////////////////
Overlay = menu.add_child("Overlay", parent)
menu.add_delimiter("Draw Settings", Overlay)
menu.add_option_value("Text Size", "overlayTextSize", 40, 20, 60, 1, Overlay, "Units")
menu.add_option_value("Text Pos X", "overlayTextX", 150, 20, 1000, 5, Overlay, "Pixles")
menu.add_option_value("Text Pos Y", "overlayTextY", 900, 20, 1000, 5, Overlay, "Pixles")

--//////////////////////////////
--//Other                     //
--//////////////////////////////
Other = menu.add_child("Other", parent)
menu.add_option("~r~Quick Close", hashQuickClose, Other, quickClose)

--//////////////////////////////
--//Other                     //
--//////////////////////////////
About = menu.add_child("About", parent)
menu.add_delimiter("Credits", About)
menu.add_child("Acid_Burn9#4371", About)

notify.above_map("~g~Monke Gaming V0.1")
system.add_task("MainScript", "sexyHash", -1, overlayDraw)
menu.update_root_parent(true)
