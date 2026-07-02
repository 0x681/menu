local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()

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
})

local Tabs = {
    ESP     = Window:AddTab("ESP"),
    Aim     = Window:AddTab("Aim"),
    Chams   = Window:AddTab("Chams"),
    Visuals = Window:AddTab("Visuals"),
    Exploits = Window:AddTab("Exploits"),
    Players = Window:AddTab("Players"),
    Config  = Window:AddTab("Config"),
}

local function bind(elem, key, transform)
    if not elem then return elem end
    elem:OnChanged(function(v)
        State.flags[key] = transform and transform(v) or v
        pcall(getgenv().Xenon_AimSync)
    end)
    return elem
end

local function bindColor(elem, key)
    if not elem then return elem end
    elem:OnChanged(function(c)
        State.colors[key] = c
    end)
    return elem
end

do
    local LeftGB = Tabs.ESP:AddLeftGroupbox("Players")
    bind(LeftGB:AddToggle("e_box",        { Text = "Box ESP",        Default = false }), "esp_box")
    bind(LeftGB:AddToggle("e_name",       { Text = "Name",           Default = false }), "esp_name")
    bind(LeftGB:AddToggle("e_dist",       { Text = "Distance",       Default = false }), "esp_distance")
    bind(LeftGB:AddToggle("e_hp",         { Text = "Health Bar",     Default = false }), "esp_healthbar")
    bind(LeftGB:AddToggle("e_item",       { Text = "Held Item",      Default = false }), "esp_held_item")
    bind(LeftGB:AddToggle("e_team",       { Text = "Team Colors",    Default = false }), "esp_team_color")
    bind(LeftGB:AddToggle("e_hidefriend", { Text = "Hide Teammates", Default = false }), "esp_hide_friendly")
    bind(LeftGB:AddToggle("e_dead",       { Text = "Dead Check",     Default = false }), "esp_dead_check")
    bind(LeftGB:AddSlider("e_deadrad",    { Text = "Dead Radius",    Default = 3,    Min = 1,   Max = 20,   Rounding = 0 }), "esp_dead_radius")
    bind(LeftGB:AddSlider("e_maxdist",    { Text = "Max Distance",   Default = 2000, Min = 100, Max = 5000, Rounding = 0 }), "esp_max_distance")

    local RightGB = Tabs.ESP:AddRightGroupbox("Colors")
    local ec_enemy = RightGB:AddToggle("ec_ecol_on",  { Text = "Enemy Color",    Default = false })
    bind(ec_enemy, "esp_box")
    bindColor(ec_enemy:AddColorPicker("ec_enemy",   { Default = State.colors.esp_enemy }), "esp_enemy")

    local ec_friend = RightGB:AddToggle("ec_fcol_on", { Text = "Friendly Color", Default = false })
    bind(ec_friend, "esp_box")
    bindColor(ec_friend:AddColorPicker("ec_friend",  { Default = State.colors.esp_friendly }), "esp_friendly")

    local ec_dist = RightGB:AddToggle("ec_dcol_on",   { Text = "Distance Color", Default = false })
    bind(ec_dist, "esp_box")
    bindColor(ec_dist:AddColorPicker("ec_dist",    { Default = State.colors.esp_distance }), "esp_distance_color")

    local ec_dead = RightGB:AddToggle("ec_deadcol_on",{ Text = "Dead Color",     Default = false })
    bind(ec_dead, "esp_box")
    bindColor(ec_dead:AddColorPicker("ec_dead",    { Default = State.colors.esp_dead }), "esp_dead")

    local ec_hp = RightGB:AddToggle("ec_hpcol_on",    { Text = "Health Color",   Default = false })
    bind(ec_hp, "esp_box")
    bindColor(ec_hp:AddColorPicker("ec_hp",      { Default = State.colors.esp_healthbar }), "esp_healthbar_color")
end

do
    local LeftGB = Tabs.Aim:AddLeftGroupbox("Silent Aim")
    bind(LeftGB:AddToggle("sa_on",     { Text = "Enabled",       Default = false }), "silent_aim_enabled")
    bind(LeftGB:AddSlider("sa_fov",    { Text = "FOV",           Default = 180, Min = 1, Max = 360, Rounding = 0 }), "silent_aim_fov")
    bind(LeftGB:AddSlider("sa_chance", { Text = "Hit Chance",    Default = 100, Min = 1, Max = 100, Rounding = 0 }), "silent_aim_hit_chance")
    local fov_ring = LeftGB:AddToggle("sa_ring", { Text = "Show FOV Ring", Default = false })
    bind(fov_ring, "silent_aim_show_fov")
    bindColor(fov_ring:AddColorPicker("sa_ringcol", { Default = State.colors.fov_circle }), "fov_circle")
    bind(LeftGB:AddDropdown("sa_hitbox", {
        Values = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
        Default = 1,
    }), "silent_aim_hitbox", function(v) return ({Head="Head", HumanoidRootPart="HumanoidRootPart", UpperTorso="UpperTorso", LowerTorso="LowerTorso"})[v] or v end)

    local RightGB = Tabs.Aim:AddRightGroupbox("Combat")
    bind(RightGB:AddToggle("ka_on",    { Text = "Kill Aura",   Default = false }), "kill_aura_enabled")
    bind(RightGB:AddSlider("ka_range", { Text = "Aura Range",  Default = 12, Min = 5, Max = 60, Rounding = 0 }), "kill_aura_range")
    bind(RightGB:AddToggle("as_on",    { Text = "Auto Shoot",  Default = false }), "auto_shoot_enabled")
    bind(RightGB:AddToggle("ar_on",    { Text = "Auto Reload", Default = false }), "auto_reload_enabled")
end

do
    local LeftGB = Tabs.Chams:AddLeftGroupbox("Player Chams")
    bind(LeftGB:AddToggle("pc_on",  { Text = "Enabled",  Default = false }), "chams")
    bind(LeftGB:AddDropdown("pc_mat", {
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = 1,
    }), "chams_material", function(v) return ({Neon="Neon",Glass="Glass",ForceField="ForceField",SmoothPlastic="SmoothPlastic"})[v] or v end)
    bind(LeftGB:AddToggle("pc_rb",  { Text = "Rainbow",  Default = false }), "chams_rainbow")
    local pc_ecol = LeftGB:AddToggle("pc_ecol_on", { Text = "Enemy Color",    Default = false })
    bind(pc_ecol, "chams")
    bindColor(pc_ecol:AddColorPicker("pc_ecol", { Default = State.colors.chams_enemy }), "chams_enemy")
    local pc_fcol = LeftGB:AddToggle("pc_fcol_on", { Text = "Friendly Color", Default = false })
    bind(pc_fcol, "chams")
    bindColor(pc_fcol:AddColorPicker("pc_fcol", { Default = State.colors.chams_friendly }), "chams_friendly")

    local RightGB = Tabs.Chams:AddRightGroupbox("Viewmodel & Gun")
    RightGB:AddLabel("Viewmodel Chams")
    bind(RightGB:AddToggle("vc_on",  { Text = "Enabled",  Default = false }), "viewmodel_chams")
    bind(RightGB:AddDropdown("vc_mat", {
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = 1,
    }), "viewmodel_chams_material", function(v) return ({Neon="Neon",Glass="Glass",ForceField="ForceField",SmoothPlastic="SmoothPlastic"})[v] or v end)
    bind(RightGB:AddToggle("vc_rb",  { Text = "Rainbow",  Default = false }), "viewmodel_chams_rainbow")
    local vc_col = RightGB:AddToggle("vc_col_on", { Text = "Color", Default = false })
    bind(vc_col, "viewmodel_chams")
    bindColor(vc_col:AddColorPicker("vc_col", { Default = State.colors.viewmodel_chams }), "viewmodel_chams")

    RightGB:AddLabel("Gun Chams")
    bind(RightGB:AddToggle("gc_on",  { Text = "Enabled",  Default = false }), "gun_material_enabled")
    bind(RightGB:AddDropdown("gc_mat", {
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = 1,
    }), "gun_material", function(v) return ({Neon="Neon",Glass="Glass",ForceField="ForceField",SmoothPlastic="SmoothPlastic"})[v] or v end)
    bind(RightGB:AddToggle("gc_rb",  { Text = "Rainbow",  Default = false }), "gun_color_rainbow")
    local gc_col = RightGB:AddToggle("gc_col_on", { Text = "Color Override", Default = false })
    bind(gc_col, "gun_color_override")
    bindColor(gc_col:AddColorPicker("gc_col", { Default = State.colors.gun_color }), "gun_color")
    local gc_out = RightGB:AddToggle("gc_out_on", { Text = "Outline", Default = false })
    bind(gc_out, "gun_outline_enabled")
    bindColor(gc_out:AddColorPicker("gc_out_col", { Default = State.colors.gun_outline_color }), "gun_outline_color")
end

do
    local LeftGB = Tabs.Visuals:AddLeftGroupbox("World Chams")
    bind(LeftGB:AddToggle("wc_on",   { Text = "Enabled",       Default = false }), "world_chams")
    bind(LeftGB:AddDropdown("wc_mode", {
        Values = { "Fade", "Solid" },
        Default = 1,
    }), "world_chams_mode", function(v) return ({Fade="Fade",Solid="Solid"})[v] or v end)
    bind(LeftGB:AddSlider("wc_range", { Text = "Range",        Default = 200, Min = 20, Max = 800, Rounding = 0 }), "world_chams_range")
    bind(LeftGB:AddSlider("wc_tr",    { Text = "Transparency", Default = 60,  Min = 0,  Max = 95,  Rounding = 0 }),
        "world_chams_transparency", function(v) return v / 100 end)
    bind(LeftGB:AddDropdown("wc_mat", {
        Values = { "Glass", "Neon", "ForceField", "SmoothPlastic" },
        Default = 1,
    }), "world_chams_material", function(v) return ({Glass="Glass",Neon="Neon",ForceField="ForceField",SmoothPlastic="SmoothPlastic"})[v] or v end)
    local wc_col = LeftGB:AddToggle("wc_col_on", { Text = "Color Override", Default = false })
    bind(wc_col, "world_chams_color_override")
    bindColor(wc_col:AddColorPicker("wc_col", { Default = State.colors.world_chams_color }), "world_chams_color")

    local RightGB = Tabs.Visuals:AddRightGroupbox("Lighting")
    bind(RightGB:AddToggle("w_nofog",  { Text = "No Fog",            Default = false }), "no_fog")
    bind(RightGB:AddToggle("w_bright", { Text = "Bright Lighting",   Default = false }), "bright_lighting")
    bind(RightGB:AddToggle("w_noatm",  { Text = "No Atmosphere",     Default = false }), "no_atmosphere")
    bind(RightGB:AddToggle("w_nodof",  { Text = "No Depth of Field", Default = false }), "no_depth_of_field")
    bind(RightGB:AddToggle("w_noblur", { Text = "No Damage Blur",    Default = false }), "no_damage_blur")
    local nv = RightGB:AddToggle("w_nv", { Text = "Night Vision",  Default = false })
    bind(nv, "night_vision")
    bindColor(nv:AddColorPicker("w_nvcol", { Default = State.colors.night_vision_tint }), "night_vision_tint")
    local tv = RightGB:AddToggle("w_tv", { Text = "Thermal Vision", Default = false })
    bind(tv, "thermal_vision")
    bindColor(tv:AddColorPicker("w_tvcol", { Default = State.colors.thermal_tint }), "thermal_tint")
end

do
    local LeftGB = Tabs.Visuals:AddLeftGroupbox("Tracers")
    bind(LeftGB:AddToggle("tr_on",  { Text = "Enabled",  Default = false }), "custom_tracers_enabled")
    bind(LeftGB:AddDropdown("tr_mat", {
        Values = { "Neon", "Glass", "ForceField", "SmoothPlastic" },
        Default = 1,
    }), "tracer_material", function(v) return ({Neon="Neon",Glass="Glass",ForceField="ForceField",SmoothPlastic="SmoothPlastic"})[v] or v end)
    bind(LeftGB:AddToggle("tr_rb",  { Text = "Rainbow",  Default = false }), "tracer_rainbow")
    local tr_col = LeftGB:AddToggle("tr_col_on", { Text = "Color", Default = false })
    bind(tr_col, "custom_tracers_enabled")
    bindColor(tr_col:AddColorPicker("tr_col", { Default = State.colors.tracer_color }), "tracer_color")

    local RightGB = Tabs.Visuals:AddRightGroupbox("Grenade Helper")
    bind(RightGB:AddToggle("gh_on",     { Text = "Enabled",    Default = true  }), "grenade_helper_enabled")
    bind(RightGB:AddDropdown("gh_cmode", {
        Values = { "Solid", "Rainbow" },
        Default = 1,
    }), "grenade_color_mode", function(v) return ({Solid="Solid",Rainbow="Rainbow"})[v] or v end)
    bind(RightGB:AddDropdown("gh_line", {
        Values = { "Solid", "Dashed" },
        Default = 1,
    }), "grenade_line_style", function(v) return ({Solid="Solid",Dashed="Dashed"})[v] or v end)
    local gh_trail = RightGB:AddToggle("gh_tcol_on", { Text = "Trail Color",  Default = false })
    bind(gh_trail, "grenade_helper_enabled")
    bindColor(gh_trail:AddColorPicker("gh_tcol", { Default = State.colors.grenade_trail }), "grenade_trail")
    local gh_impact = RightGB:AddToggle("gh_icol_on", { Text = "Impact Color", Default = false })
    bind(gh_impact, "grenade_helper_enabled")
    bindColor(gh_impact:AddColorPicker("gh_icol", { Default = State.colors.grenade_impact }), "grenade_impact")
end

do
    local LeftGB = Tabs.Exploits:AddLeftGroupbox("Weapon")
    bind(LeftGB:AddToggle("wx_spread",  { Text = "No Spread",      Default = false }), "weapon_no_spread")
    bind(LeftGB:AddToggle("wx_recoil",  { Text = "No Recoil",      Default = false }), "weapon_no_recoil")
    bind(LeftGB:AddToggle("wx_sway",    { Text = "No Sway",        Default = false }), "weapon_no_sway")
    bind(LeftGB:AddToggle("wx_ads",     { Text = "Instant ADS",    Default = false }), "weapon_instant_ads")
    bind(LeftGB:AddToggle("wx_rf",      { Text = "Rapid Fire",     Default = false }), "weapon_rapid_fire")
    bind(LeftGB:AddSlider("wx_rfmult",  { Text = "Fire Rate Mult", Default = 2, Min = 1, Max = 10, Rounding = 1 }), "weapon_rapid_fire_mult")
    bind(LeftGB:AddToggle("wx_range",   { Text = "Extended Range", Default = false }), "weapon_extended_range")
    bind(LeftGB:AddToggle("wx_melee",   { Text = "Extended Melee", Default = false }), "weapon_extended_melee_range")
    bind(LeftGB:AddSlider("wx_melmult", { Text = "Melee Mult",     Default = 3, Min = 1, Max = 10, Rounding = 1 }), "weapon_extended_melee_mult")

    local RightGB = Tabs.Exploits:AddRightGroupbox("Hit Feedback")
    bind(RightGB:AddToggle("hf_hit",   { Text = "Hit Sound",    Default = false }), "hit_sound_enabled")
    bind(RightGB:AddSlider("hf_hvol",  { Text = "Hit Volume",   Default = 1, Min = 0, Max = 2, Rounding = 2 }), "hit_sound_volume")
    bind(RightGB:AddToggle("hf_death", { Text = "Death Sound",  Default = false }), "death_sound_enabled")
    bind(RightGB:AddSlider("hf_dvol",  { Text = "Death Volume", Default = 1, Min = 0, Max = 2, Rounding = 2 }), "death_sound_volume")
    local hf_fx = RightGB:AddToggle("hf_fx", { Text = "Hit Effect", Default = false })
    bind(hf_fx, "hit_effect_enabled")
    bindColor(hf_fx:AddColorPicker("hf_fxcol", { Default = State.colors.hit_effect }), "hit_effect")
end

do
    local LeftGB = Tabs.Players:AddLeftGroupbox("Playerlist")
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

    local RightGB = Tabs.Players:AddRightGroupbox("Actions")
    local pl_selected = nil

    RightGB:AddButton({
        Text = "Whitelist Toggle",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            whitelist[pl_selected] = not whitelist[pl_selected]
            notify((whitelist[pl_selected] and "Whitelisted: " or "Unwhitelisted: ") .. pl_selected)
        end,
    })

    RightGB:AddButton({
        Text = "Priority Toggle",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            priority_list[pl_selected] = not priority_list[pl_selected]
            notify((priority_list[pl_selected] and "Priority set: " or "Priority removed: ") .. pl_selected)
        end,
    })

    RightGB:AddButton({
        Text = "Teleport To",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" and inst:GetAttribute("Xenon_owner_name") == pl_selected then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        notify("Teleported to " .. pl_selected)
                        return
                    end
                end
            end
            notify("Could not find " .. pl_selected)
        end,
    })

    RightGB:AddButton({
        Text = "Kill",
        Func = function()
            if not pl_selected or pl_selected == "" then notify("No player selected") return end
            local self_char = players.LocalPlayer.Character
            local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
            if not root then notify("No character") return end
            for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
                if inst.Name == "soldier_model" and inst:GetAttribute("Xenon_owner_name") == pl_selected then
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
            notify("Could not find " .. pl_selected)
        end,
    })

    getgenv().Xenon_whitelist = whitelist
    getgenv().Xenon_priority  = priority_list
end

do
    local LeftGB = Tabs.Config:AddLeftGroupbox("Configurations")
    local cfg_selected = ""
    LeftGB:AddInput("cfg_name", { Text = "Config Name", Default = "" })

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

    LeftGB:AddButton({
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

    LeftGB:AddButton({
        Text = "Save",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            Library:AttemptSave()
            notify("Saved: " .. cfg_selected)
        end,
    })

    LeftGB:AddButton({
        Text = "Load",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            Library:LoadConfig(cfg_selected)
            notify("Loaded: " .. cfg_selected)
        end,
    })

    LeftGB:AddButton({
        Text = "Delete",
        Func = function()
            if cfg_selected == "" then notify("Select a config") return end
            local cfg_dir = Library.FolderName .. "/configs"
            pcall(delfile, cfg_dir .. "/" .. cfg_selected .. ".cfg")
            notify("Deleted: " .. cfg_selected)
            refresh_configs()
        end,
    })

    LeftGB:AddButton({
        Text = "Refresh",
        Func = refresh_configs,
    })

    local RightGB = Tabs.Config:AddRightGroupbox("Interface")
    local cp = RightGB:AddToggle("ui_accent", { Text = "Accent Color", Default = false })
    bindColor(cp:AddColorPicker("accent_picker", { Default = Color3.fromRGB(220, 50, 50) }), "ui_accent")

    RightGB:AddButton({
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
