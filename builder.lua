local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/UI-Libraries/main/LinoriaLib/source.lua"))()

local State   = getgenv().State
local players = game:GetService("Players")

local whitelist     = {}
local priority_list = {}

local function notify(msg)
    pcall(function() Library:Notify(msg, 3) end)
end

local Window = Library:CreateWindow({
    Title = "xenon  |  frontlines",
    Position = UDim2.fromOffset(175, 50),
    Size = UDim2.fromOffset(570, 620),
    Center = false,
})

local TabESP     = Window:AddTab("ESP")
local TabAim     = Window:AddTab("Aim")
local TabChams   = Window:AddTab("Chams")
local TabVisuals = Window:AddTab("Visuals")
local TabExploit = Window:AddTab("Exploits")
local TabPlayers = Window:AddTab("Players")
local TabCfg     = Window:AddTab("Config")

local function bind(elem, key, transform)
    if not elem then return elem end
    local orig_cb = elem.Callback
    elem.Callback = function(v)
        State.flags[key] = transform and transform(v) or v
        if orig_cb then orig_cb(v) end
        pcall(getgenv().Xenon_AimSync)
    end
    return elem
end

local function bindColor(elem, key)
    if not elem then return elem end
    local orig_cb = elem.Callback
    elem.Callback = function(c)
        State.colors[key] = c
        if orig_cb then orig_cb(c) end
    end
    return elem
end

do
    local GroupPlayers = TabESP:AddGroupbox("Players")
    bind(GroupPlayers:AddToggle("e_box",        { Text = "Box ESP",        Default = false }), "esp_box")
    bind(GroupPlayers:AddToggle("e_name",       { Text = "Name",           Default = false }), "esp_name")
    bind(GroupPlayers:AddToggle("e_dist",       { Text = "Distance",       Default = false }), "esp_distance")
    bind(GroupPlayers:AddToggle("e_hp",         { Text = "Health Bar",     Default = false }), "esp_healthbar")
    bind(GroupPlayers:AddToggle("e_item",       { Text = "Held Item",      Default = false }), "esp_held_item")
    bind(GroupPlayers:AddToggle("e_team",       { Text = "Team Colors",    Default = false }), "esp_team_color")
    bind(GroupPlayers:AddToggle("e_hidefriend", { Text = "Hide Teammates", Default = false }), "esp_hide_friendly")
    bind(GroupPlayers:AddToggle("e_dead",       { Text = "Dead Check",     Default = false }), "esp_dead_check")
    bind(GroupPlayers:AddSlider("e_deadrad",    { Text = "Dead Radius",    Default = 3,    Min = 1,   Max = 20,   Rounding = 0 }), "esp_dead_radius")
    bind(GroupPlayers:AddSlider("e_maxdist",    { Text = "Max Distance",   Default = 2000, Min = 100, Max = 5000, Rounding = 0 }), "esp_max_distance")

    local GroupColors = TabESP:AddGroupbox("Colors")
    local ec_enemy = GroupColors:AddToggle("ec_ecol_on",  { Text = "Enemy Color",    Default = false })
    bind(ec_enemy, "esp_box")
    bindColor(ec_enemy:AddColorPicker("ec_enemy",   { Default = State.colors.esp_enemy }), "esp_enemy")

    local ec_friend = GroupColors:AddToggle("ec_fcol_on", { Text = "Friendly Color", Default = false })
    bind(ec_friend, "esp_box")
    bindColor(ec_friend:AddColorPicker("ec_friend",  { Default = State.colors.esp_friendly }), "esp_friendly")

    local ec_dist = GroupColors:AddToggle("ec_dcol_on",   { Text = "Distance Color", Default = false })
    bind(ec_dist, "esp_box")
    bindColor(ec_dist:AddColorPicker("ec_dist",    { Default = State.colors.esp_distance }), "esp_distance_color")

    local ec_dead = GroupColors:AddToggle("ec_deadcol_on",{ Text = "Dead Color",     Default = false })
    bind(ec_dead, "esp_box")
    bindColor(ec_dead:AddColorPicker("ec_dead",    { Default = State.colors.esp_dead }), "esp_dead")

    local ec_hp = GroupColors:AddToggle("ec_hpcol_on",    { Text = "Health Color",   Default = false })
    bind(ec_hp, "esp_box")
    bindColor(ec_hp:AddColorPicker("ec_hp",      { Default = State.colors.esp_healthbar }), "esp_healthbar_color")
end

do
    local GroupSilent = TabAim:AddGroupbox("Silent Aim")
    bind(GroupSilent:AddToggle("sa_on",     { Text = "Enabled",       Default = false }), "silent_aim_enabled")
    bind(GroupSilent:AddSlider("sa_fov",    { Text = "FOV",           Default = 180, Min = 1, Max = 360, Rounding = 0 }), "silent_aim_fov")
    bind(GroupSilent:AddSlider("sa_chance", { Text = "Hit Chance",    Default = 100, Min = 1, Max = 100, Rounding = 0 }), "silent_aim_hit_chance")
    local fov_ring = GroupSilent:AddToggle("sa_ring", { Text = "Show FOV Ring", Default = false })
    bind(fov_ring, "silent_aim_show_fov")
    bindColor(fov_ring:AddColorPicker("sa_ringcol", { Default = State.colors.fov_circle }), "fov_circle")
    bind(GroupSilent:AddDropdown("sa_hitbox", {
        Text = "Hitbox",
        Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
        Default = "Head",
    }), "silent_aim_hitbox")

    local GroupCombat = TabAim:AddGroupbox("Combat")
    bind(GroupCombat:AddToggle("ka_on",    { Text = "Kill Aura",   Default = false }), "kill_aura_enabled")
    bind(GroupCombat:AddSlider("ka_range", { Text = "Aura Range",  Default = 12, Min = 5, Max = 60, Rounding = 0 }), "kill_aura_range")
    bind(GroupCombat:AddToggle("as_on",    { Text = "Auto Shoot",  Default = false }), "auto_shoot_enabled")
    bind(GroupCombat:AddToggle("ar_on",    { Text = "Auto Reload", Default = false }), "auto_reload_enabled")
end

do
    local GroupPlayer = TabChams:AddGroupbox("Player Chams")
    bind(GroupPlayer:AddToggle("pc_on",  { Text = "Enabled",  Default = false }), "chams")
    bind(GroupPlayer:AddDropdown("pc_mat", {
        Text = "Material",
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = "Neon",
    }), "chams_material")
    bind(GroupPlayer:AddToggle("pc_rb",  { Text = "Rainbow",  Default = false }), "chams_rainbow")
    local pc_ecol = GroupPlayer:AddToggle("pc_ecol_on", { Text = "Enemy Color",    Default = false })
    bind(pc_ecol, "chams")
    bindColor(pc_ecol:AddColorPicker("pc_ecol", { Default = State.colors.chams_enemy }), "chams_enemy")
    local pc_fcol = GroupPlayer:AddToggle("pc_fcol_on", { Text = "Friendly Color", Default = false })
    bind(pc_fcol, "chams")
    bindColor(pc_fcol:AddColorPicker("pc_fcol", { Default = State.colors.chams_friendly }), "chams_friendly")

    local GroupViewmodel = TabChams:AddGroupbox("Viewmodel Chams")
    bind(GroupViewmodel:AddToggle("vc_on",  { Text = "Enabled",  Default = false }), "viewmodel_chams")
    bind(GroupViewmodel:AddDropdown("vc_mat", {
        Text = "Material",
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = "Neon",
    }), "viewmodel_chams_material")
    bind(GroupViewmodel:AddToggle("vc_rb",  { Text = "Rainbow",  Default = false }), "viewmodel_chams_rainbow")
    local vc_col = GroupViewmodel:AddToggle("vc_col_on", { Text = "Color", Default = false })
    bind(vc_col, "viewmodel_chams")
    bindColor(vc_col:AddColorPicker("vc_col", { Default = State.colors.viewmodel_chams }), "viewmodel_chams")

    local GroupGun = TabChams:AddGroupbox("Gun Chams")
    bind(GroupGun:AddToggle("gc_on",  { Text = "Enabled",  Default = false }), "gun_material_enabled")
    bind(GroupGun:AddDropdown("gc_mat", {
        Text = "Material",
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = "Neon",
    }), "gun_material")
    bind(GroupGun:AddToggle("gc_rb",  { Text = "Rainbow",  Default = false }), "gun_color_rainbow")
    local gc_col = GroupGun:AddToggle("gc_col_on", { Text = "Color Override", Default = false })
    bind(gc_col, "gun_color_override")
    bindColor(gc_col:AddColorPicker("gc_col", { Default = State.colors.gun_color }), "gun_color")
    local gc_out = GroupGun:AddToggle("gc_out_on", { Text = "Outline", Default = false })
    bind(gc_out, "gun_outline_enabled")
    bindColor(gc_out:AddColorPicker("gc_out_col", { Default = State.colors.gun_outline_color }), "gun_outline_color")
end

do
    local GroupWorld = TabVisuals:AddGroupbox("World Chams")
    bind(GroupWorld:AddToggle("wc_on",   { Text = "Enabled",       Default = false }), "world_chams")
    bind(GroupWorld:AddDropdown("wc_mode", {
        Text = "Mode",
        Values = { "Fade", "Solid" },
        Default = "Fade",
    }), "world_chams_mode")
    bind(GroupWorld:AddSlider("wc_range", { Text = "Range",        Default = 200, Min = 20, Max = 800, Rounding = 0 }), "world_chams_range")
    bind(GroupWorld:AddSlider("wc_tr",    { Text = "Transparency", Default = 60,  Min = 0,  Max = 95,  Rounding = 0 }),
        "world_chams_transparency", function(v) return v / 100 end)
    bind(GroupWorld:AddDropdown("wc_mat", {
        Text = "Material",
        Values = { "Glass", "Neon", "ForceField", "SmoothPlastic" },
        Default = "Glass",
    }), "world_chams_material")
    local wc_col = GroupWorld:AddToggle("wc_col_on", { Text = "Color Override", Default = false })
    bind(wc_col, "world_chams_color_override")
    bindColor(wc_col:AddColorPicker("wc_col", { Default = State.colors.world_chams_color }), "world_chams_color")

    local GroupLight = TabVisuals:AddGroupbox("Lighting")
    bind(GroupLight:AddToggle("w_nofog",  { Text = "No Fog",            Default = false }), "no_fog")
    bind(GroupLight:AddToggle("w_bright", { Text = "Bright Lighting",   Default = false }), "bright_lighting")
    bind(GroupLight:AddToggle("w_noatm",  { Text = "No Atmosphere",     Default = false }), "no_atmosphere")
    bind(GroupLight:AddToggle("w_nodof",  { Text = "No Depth of Field", Default = false }), "no_depth_of_field")
    bind(GroupLight:AddToggle("w_noblur", { Text = "No Damage Blur",    Default = false }), "no_damage_blur")
    local nv = GroupLight:AddToggle("w_nv", { Text = "Night Vision",  Default = false })
    bind(nv, "night_vision")
    bindColor(nv:AddColorPicker("w_nvcol", { Default = State.colors.night_vision_tint }), "night_vision_tint")
    local tv = GroupLight:AddToggle("w_tv", { Text = "Thermal Vision", Default = false })
    bind(tv, "thermal_vision")
    bindColor(tv:AddColorPicker("w_tvcol", { Default = State.colors.thermal_tint }), "thermal_tint")

    local GroupTracers = TabVisuals:AddGroupbox("Tracers")
    bind(GroupTracers:AddToggle("tr_on",  { Text = "Enabled",  Default = false }), "custom_tracers_enabled")
    bind(GroupTracers:AddDropdown("tr_mat", {
        Text = "Material",
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = "Neon",
    }), "tracer_material")
    bind(GroupTracers:AddToggle("tr_rb",  { Text = "Rainbow",  Default = false }), "tracer_rainbow")
    local tr_col = GroupTracers:AddToggle("tr_col_on", { Text = "Color", Default = false })
    bind(tr_col, "custom_tracers_enabled")
    bindColor(tr_col:AddColorPicker("tr_col", { Default = State.colors.tracer_color }), "tracer_color")

    local GroupGrenade = TabVisuals:AddGroupbox("Grenade Helper")
    bind(GroupGrenade:AddToggle("gh_on",     { Text = "Enabled",    Default = true  }), "grenade_helper_enabled")
    bind(GroupGrenade:AddDropdown("gh_cmode", {
        Text = "Color Mode",
        Values = { "Solid", "Rainbow" },
        Default = "Solid",
    }), "grenade_color_mode")
    bind(GroupGrenade:AddDropdown("gh_line", {
        Text = "Line Style",
        Values = { "Solid", "Dashed" },
        Default = "Solid",
    }), "grenade_line_style")
    local gh_trail = GroupGrenade:AddToggle("gh_tcol_on", { Text = "Trail Color",  Default = false })
    bind(gh_trail, "grenade_helper_enabled")
    bindColor(gh_trail:AddColorPicker("gh_tcol", { Default = State.colors.grenade_trail }), "grenade_trail")
    local gh_impact = GroupGrenade:AddToggle("gh_icol_on", { Text = "Impact Color", Default = false })
    bind(gh_impact, "grenade_helper_enabled")
    bindColor(gh_impact:AddColorPicker("gh_icol", { Default = State.colors.grenade_impact }), "grenade_impact")
end

do
    local GroupWeapon = TabExploit:AddGroupbox("Weapon")
    bind(GroupWeapon:AddToggle("wx_spread",  { Text = "No Spread",      Default = false }), "weapon_no_spread")
    bind(GroupWeapon:AddToggle("wx_recoil",  { Text = "No Recoil",      Default = false }), "weapon_no_recoil")
    bind(GroupWeapon:AddToggle("wx_sway",    { Text = "No Sway",        Default = false }), "weapon_no_sway")
    bind(GroupWeapon:AddToggle("wx_ads",     { Text = "Instant ADS",    Default = false }), "weapon_instant_ads")
    bind(GroupWeapon:AddToggle("wx_rf",      { Text = "Rapid Fire",     Default = false }), "weapon_rapid_fire")
    bind(GroupWeapon:AddSlider("wx_rfmult",  { Text = "Fire Rate Mult", Default = 2, Min = 1, Max = 10, Rounding = 1 }), "weapon_rapid_fire_mult")
    bind(GroupWeapon:AddToggle("wx_range",   { Text = "Extended Range", Default = false }), "weapon_extended_range")
    bind(GroupWeapon:AddToggle("wx_melee",   { Text = "Extended Melee", Default = false }), "weapon_extended_melee_range")
    bind(GroupWeapon:AddSlider("wx_melmult", { Text = "Melee Mult",     Default = 3, Min = 1, Max = 10, Rounding = 1 }), "weapon_extended_melee_mult")

    local GroupHit = TabExploit:AddGroupbox("Hit Feedback")
    bind(GroupHit:AddToggle("hf_hit",   { Text = "Hit Sound",    Default = false }), "hit_sound_enabled")
    bind(GroupHit:AddSlider("hf_hvol",  { Text = "Hit Volume",   Default = 1, Min = 0, Max = 2, Rounding = 2 }), "hit_sound_volume")
    bind(GroupHit:AddToggle("hf_death", { Text = "Death Sound",  Default = false }), "death_sound_enabled")
    bind(GroupHit:AddSlider("hf_dvol",  { Text = "Death Volume", Default = 1, Min = 0, Max = 2, Rounding = 2 }), "death_sound_volume")
    local hf_fx = GroupHit:AddToggle("hf_fx", { Text = "Hit Effect", Default = false })
    bind(hf_fx, "hit_effect_enabled")
    bindColor(hf_fx:AddColorPicker("hf_fxcol", { Default = State.colors.hit_effect }), "hit_effect")
end

do
    local GroupList = TabPlayers:AddGroupbox("Playerlist")
    local pl_list = GroupList:AddLabel("Players")

    local player_names = {}
    task.spawn(function()
        while Library.Folder and Library.Folder.Parent do
            local self_player = players.LocalPlayer
            player_names = {}
            for _, p in ipairs(players:GetPlayers()) do
                if p ~= self_player then table.insert(player_names, p.Name) end
            end
            task.wait(3)
        end
    end)

    local GroupActions = TabPlayers:AddGroupbox("Actions")
    local pl_selected = nil

    GroupActions:AddButton({
        Text = "Whitelist Toggle",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            whitelist[pl_selected] = not whitelist[pl_selected]
            notify((whitelist[pl_selected] and "Whitelisted: " or "Unwhitelisted: ") .. pl_selected)
        end,
    })

    GroupActions:AddButton({
        Text = "Priority Toggle",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            priority_list[pl_selected] = not priority_list[pl_selected]
            notify((priority_list[pl_selected] and "Priority set: " or "Priority removed: ") .. pl_selected)
        end,
    })

    GroupActions:AddButton({
        Text = "Teleport To",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" then
                    if inst:GetAttribute("Xenon_owner_name") == pl_selected then
                        local hrp = inst:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                            notify("Teleported to " .. pl_selected)
                            return
                        end
                    end
                end
            end
            notify("Could not find " .. pl_selected)
        end,
    })

    GroupActions:AddButton({
        Text = "Kill",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" then
                    if inst:GetAttribute("Xenon_owner_name") == pl_selected then
                        local hrp = inst:FindFirstChild("HumanoidRootPart")
                        if hrp then
                            root.CFrame = hrp.CFrame * CFrame.new(0, 1, 2)
                            local prev = State.flags.auto_shoot_enabled
                            State.flags.auto_shoot_enabled = true
                            pcall(getgenv().Xenon_AimSync)
                            task.delay(1.5, function()
                                State.flags.auto_shoot_enabled = prev
                                pcall(getgenv().Xenon_AimSync)
                            end)
                            notify("Killing " .. pl_selected)
                            return
                        end
                    end
                end
            end
            notify("Could not find " .. pl_selected)
        end,
    })

    local GroupWhitelist = TabPlayers:AddGroupbox("Whitelist")
    GroupWhitelist:AddButton({
        Text = "Refresh",
        Func = function()
            local wl_list = {}
            for name in pairs(whitelist) do
                table.insert(wl_list, name)
            end
        end,
    })

    getgenv().Xenon_whitelist = whitelist
    getgenv().Xenon_priority  = priority_list
end

do
    local GroupCfg = TabCfg:AddGroupbox("Configurations")

    local cfg_selected = ""
    GroupCfg:AddInput("cfg_name", { Text = "Config Name", Default = "" })

    local cfg_list = {}
    local function refresh_configs()
        cfg_list = {}
        local cfg_dir = Library.FolderName .. "/configs"
        pcall(function() if not isfolder(cfg_dir) then makefolder(cfg_dir) end end)
        local ok, files = pcall(listfiles, cfg_dir)
        if ok and files then
            for _, f in ipairs(files) do
                local n = f:match("([^/\\]+)%.cfg$")
                if n then table.insert(cfg_list, n) end
            end
        end
    end
    refresh_configs()

    GroupCfg:AddButton({
        Text = "Create",
        Func = function()
            local cfg_name = Library.Flags.cfg_name or ""
            if cfg_name == "" then notify("Enter a config name") return end
            local cfg_dir = Library.FolderName .. "/configs"
            pcall(function() if not isfolder(cfg_dir) then makefolder(cfg_dir) end end)
            Library:AttemptSave()
            notify("Created: " .. cfg_name)
            refresh_configs()
        end,
    })

    GroupCfg:AddButton({
        Text = "Save",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            Library:AttemptSave()
            notify("Saved: " .. cfg_selected)
        end,
    })

    GroupCfg:AddButton({
        Text = "Load",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            Library:LoadConfig(cfg_selected)
            notify("Loaded: " .. cfg_selected)
        end,
    })

    GroupCfg:AddButton({
        Text = "Delete",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            local cfg_dir = Library.FolderName .. "/configs"
            pcall(delfile, cfg_dir .. "/" .. cfg_selected .. ".cfg")
            notify("Deleted: " .. cfg_selected)
            refresh_configs()
        end,
    })

    GroupCfg:AddButton({
        Text = "Refresh",
        Func = refresh_configs,
    })

    local GroupUI = TabCfg:AddGroupbox("Interface")
    local cp = GroupUI:AddToggle("ui_accent", { Text = "Accent Color", Default = false })
    bindColor(cp:AddColorPicker("accent_picker", { Default = Color3.fromRGB(220, 50, 50) }), "ui_accent")

    GroupUI:AddButton({
        Text = "Unload",
        Func = function()
            notify("Unloading xenon...")
            task.delay(0.5, function()
                pcall(getgenv().run_all_cleanup)
                pcall(getgenv().Xenon_AimStop)
            end)
        end,
    })
end

task.defer(function()
    State.flags.grenade_helper_enabled = true
    pcall(getgenv().Xenon_AimSync)
end)

Library:Init()
