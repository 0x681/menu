local library, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/i77lhm/Libraries/refs/heads/main/Atlanta/Library.lua"))()

local State   = getgenv().State
local players = game:GetService("Players")
local flags   = library.flags

local whitelist     = {}
local priority_list = {}

local function notify(msg)
    pcall(function() library:notification({ text = msg, time = 3 }) end)
end

for index, value in themes.preset do
    pcall(function() library:update_theme(index, value) end)
end
library:update_theme("accent", Color3.fromRGB(220, 50, 50))

local function bind(elem, key, transform)
    if not elem then return elem end
    local cb = elem.callback
    elem.callback = function(v)
        State.flags[key] = transform and transform(v) or v
        if cb then cb(v) end
        pcall(getgenv().Xenon_AimSync)
    end
    return elem
end

local function bindColor(elem, key)
    if not elem then return elem end
    local cb = elem.callback
    elem.callback = function(c, a)
        State.colors[key] = c
        if cb then cb(c, a) end
    end
    return elem
end

local window = library:window({
    name = "xenon  |  frontlines",
    size = UDim2.new(0, 570, 0, 620),
})

local TabESP     = window:tab({ name = "ESP"      })
local TabAim     = window:tab({ name = "Aim"      })
local TabChams   = window:tab({ name = "Chams"    })
local TabVisuals = window:tab({ name = "Visuals"  })
local TabExploit = window:tab({ name = "Exploits" })
local TabPlayers = window:tab({ name = "Players"  })
local TabCfg     = window:tab({ name = "Config"   })

-- ── ESP ──────────────────────────────────────────────────────────────────────
do
    local colL = TabESP:column()
    local colR = TabESP:column()

    local s = colL:section({ name = "Players", toggle = false })
    bind(s:toggle({ name = "Box ESP",        flag = "e_box",        default = false }), "esp_box")
    bind(s:toggle({ name = "Name",           flag = "e_name",       default = false }), "esp_name")
    bind(s:toggle({ name = "Distance",       flag = "e_dist",       default = false }), "esp_distance")
    bind(s:toggle({ name = "Health Bar",     flag = "e_hp",         default = false }), "esp_healthbar")
    bind(s:toggle({ name = "Held Item",      flag = "e_item",       default = false }), "esp_held_item")
    bind(s:toggle({ name = "Team Colors",    flag = "e_team",       default = false }), "esp_team_color")
    bind(s:toggle({ name = "Hide Teammates", flag = "e_hidefriend", default = false }), "esp_hide_friendly")
    bind(s:toggle({ name = "Dead Check",     flag = "e_dead",       default = false }), "esp_dead_check")
    bind(s:slider({ name = "Dead Radius",    flag = "e_deadrad",  min = 1,   max = 20,   default = 3,    interval = 1,  suffix = "st" }), "esp_dead_radius")
    bind(s:slider({ name = "Max Distance",   flag = "e_maxdist",  min = 100, max = 5000, default = 2000, interval = 50, suffix = "st" }), "esp_max_distance")

    local cs = colR:section({ name = "Colors", toggle = false })
    bindColor(cs:toggle({ name = "Enemy Color",    flag = "ec_ecol_on",    default = false })
        :colorpicker({ flag = "ec_enemy",   color = State.colors.esp_enemy      }), "esp_enemy")
    bindColor(cs:toggle({ name = "Friendly Color", flag = "ec_fcol_on",    default = false })
        :colorpicker({ flag = "ec_friend",  color = State.colors.esp_friendly   }), "esp_friendly")
    bindColor(cs:toggle({ name = "Distance Color", flag = "ec_dcol_on",    default = false })
        :colorpicker({ flag = "ec_dist",    color = State.colors.esp_distance   }), "esp_distance_color")
    bindColor(cs:toggle({ name = "Dead Color",     flag = "ec_deadcol_on", default = false })
        :colorpicker({ flag = "ec_dead",    color = State.colors.esp_dead       }), "esp_dead")
    bindColor(cs:toggle({ name = "Health Color",   flag = "ec_hpcol_on",   default = false })
        :colorpicker({ flag = "ec_hp",      color = State.colors.esp_healthbar  }), "esp_healthbar_color")
end

-- ── AIM ──────────────────────────────────────────────────────────────────────
do
    local colL = TabAim:column()
    local colR = TabAim:column()

    local s = colL:section({ name = "Silent Aim", toggle = false })
    bind(s:toggle({ name = "Enabled",    flag = "sa_on",     default = false }), "silent_aim_enabled")
    bind(s:slider({ name = "FOV",        flag = "sa_fov",    min = 1, max = 360, default = 180, interval = 1, suffix = "°" }), "silent_aim_fov")
    bind(s:slider({ name = "Hit Chance", flag = "sa_chance", min = 1, max = 100, default = 100, interval = 1, suffix = "%" }), "silent_aim_hit_chance")
    local fov_ring = s:toggle({ name = "Show FOV Ring", flag = "sa_ring", default = false })
    bind(fov_ring, "silent_aim_show_fov")
    bindColor(fov_ring:colorpicker({ flag = "sa_ringcol", color = State.colors.fov_circle }), "fov_circle")
    bind(s:dropdown({ name = "Hitbox", flag = "sa_hitbox",
        items   = { "Head", "HumanoidRootPart", "UpperTorso", "LowerTorso" },
        default = "Head",
    }), "silent_aim_hitbox")

    local s2 = colR:section({ name = "Combat", toggle = false })
    bind(s2:toggle({ name = "Kill Aura",   flag = "ka_on",    default = false }), "kill_aura_enabled")
    bind(s2:slider({ name = "Aura Range",  flag = "ka_range", min = 5, max = 60, default = 12, interval = 1, suffix = "st" }), "kill_aura_range")
    bind(s2:toggle({ name = "Auto Shoot",  flag = "as_on",    default = false }), "auto_shoot_enabled")
    bind(s2:toggle({ name = "Auto Reload", flag = "ar_on",    default = false }), "auto_reload_enabled")
end

-- ── CHAMS ─────────────────────────────────────────────────────────────────────
do
    local colL = TabChams:column()
    local colR = TabChams:column()

    local s = colL:section({ name = "Player Chams", toggle = false })
    bind(s:toggle({   name = "Enabled",  flag = "pc_on",  default = false }), "chams")
    bind(s:dropdown({ name = "Material", flag = "pc_mat",
        items = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, default = "Neon" }), "chams_material")
    bind(s:toggle({   name = "Rainbow",  flag = "pc_rb",  default = false }), "chams_rainbow")
    bindColor(s:toggle({ name = "Enemy Color",    flag = "pc_ecol_on", default = false })
        :colorpicker({ flag = "pc_ecol", color = State.colors.chams_enemy    }), "chams_enemy")
    bindColor(s:toggle({ name = "Friendly Color", flag = "pc_fcol_on", default = false })
        :colorpicker({ flag = "pc_fcol", color = State.colors.chams_friendly }), "chams_friendly")

    local s2 = colR:section({ name = "Viewmodel Chams", toggle = false })
    bind(s2:toggle({   name = "Enabled",  flag = "vc_on",  default = false }), "viewmodel_chams")
    bind(s2:dropdown({ name = "Material", flag = "vc_mat",
        items = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, default = "Neon" }), "viewmodel_chams_material")
    bind(s2:toggle({   name = "Rainbow",  flag = "vc_rb",  default = false }), "viewmodel_chams_rainbow")
    bindColor(s2:toggle({ name = "Color", flag = "vc_col_on", default = false })
        :colorpicker({ flag = "vc_col", color = State.colors.viewmodel_chams }), "viewmodel_chams")

    local s3 = colR:section({ name = "Gun Chams", toggle = false })
    bind(s3:toggle({   name = "Enabled",  flag = "gc_on",  default = false }), "gun_material_enabled")
    bind(s3:dropdown({ name = "Material", flag = "gc_mat",
        items = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, default = "Neon" }), "gun_material")
    bind(s3:toggle({   name = "Rainbow",  flag = "gc_rb",  default = false }), "gun_color_rainbow")
    local gc_col_t = s3:toggle({ name = "Color Override", flag = "gc_col_on", default = false })
    do
        local cb = gc_col_t.callback
        gc_col_t.callback = function(v)
            State.flags.gun_color_override = v
            if cb then cb(v) end
            pcall(getgenv().Xenon_AimSync)
        end
    end
    bindColor(gc_col_t:colorpicker({ flag = "gc_col", color = State.colors.gun_color }), "gun_color")
    local gc_out_t = s3:toggle({ name = "Outline", flag = "gc_out_on", default = false })
    do
        local cb = gc_out_t.callback
        gc_out_t.callback = function(v)
            State.flags.gun_outline_enabled = v
            if cb then cb(v) end
            pcall(getgenv().Xenon_AimSync)
        end
    end
    bindColor(gc_out_t:colorpicker({ flag = "gc_out_col", color = State.colors.gun_outline_color }), "gun_outline_color")
end

-- ── VISUALS ───────────────────────────────────────────────────────────────────
do
    local colL = TabVisuals:column()
    local colR = TabVisuals:column()

    local s = colL:section({ name = "World Chams", toggle = false })
    bind(s:toggle({   name = "Enabled",      flag = "wc_on",   default = false }), "world_chams")
    bind(s:dropdown({ name = "Mode",         flag = "wc_mode",
        items = { "Fade", "Solid" }, default = "Fade" }), "world_chams_mode")
    bind(s:slider({   name = "Range",        flag = "wc_range", min = 20, max = 800, default = 200, interval = 10, suffix = "st" }), "world_chams_range")
    bind(s:slider({   name = "Transparency", flag = "wc_tr",    min = 0,  max = 95,  default = 60,  interval = 5,  suffix = "%" }),
        "world_chams_transparency", function(v) return v / 100 end)
    bind(s:dropdown({ name = "Material",     flag = "wc_mat",
        items = { "Glass", "Neon", "ForceField", "SmoothPlastic" }, default = "Glass" }), "world_chams_material")
    bindColor(s:toggle({ name = "Color Override", flag = "wc_col_on", default = false })
        :colorpicker({ flag = "wc_col", color = State.colors.world_chams_color }), "world_chams_color")

    local s2 = colL:section({ name = "Lighting", toggle = false })
    bind(s2:toggle({ name = "No Fog",            flag = "w_nofog",  default = false }), "no_fog")
    bind(s2:toggle({ name = "Bright Lighting",   flag = "w_bright", default = false }), "bright_lighting")
    bind(s2:toggle({ name = "No Atmosphere",     flag = "w_noatm",  default = false }), "no_atmosphere")
    bind(s2:toggle({ name = "No Depth of Field", flag = "w_nodof",  default = false }), "no_depth_of_field")
    bind(s2:toggle({ name = "No Damage Blur",    flag = "w_noblur", default = false }), "no_damage_blur")
    local nv = s2:toggle({ name = "Night Vision",  flag = "w_nv", default = false })
    bind(nv, "night_vision")
    bindColor(nv:colorpicker({ flag = "w_nvcol", color = State.colors.night_vision_tint }), "night_vision_tint")
    local tv = s2:toggle({ name = "Thermal Vision", flag = "w_tv", default = false })
    bind(tv, "thermal_vision")
    bindColor(tv:colorpicker({ flag = "w_tvcol", color = State.colors.thermal_tint }), "thermal_tint")

    local s3 = colR:section({ name = "Tracers", toggle = false })
    bind(s3:toggle({   name = "Enabled",  flag = "tr_on",     default = false }), "custom_tracers_enabled")
    bind(s3:dropdown({ name = "Material", flag = "tr_mat",
        items = { "Neon", "Glass", "ForceField", "SmoothPlastic" }, default = "Neon" }), "tracer_material")
    bind(s3:toggle({   name = "Rainbow",  flag = "tr_rb",     default = false }), "tracer_rainbow")
    bindColor(s3:toggle({ name = "Color", flag = "tr_col_on", default = false })
        :colorpicker({ flag = "tr_col", color = State.colors.tracer_color }), "tracer_color")

    local s4 = colR:section({ name = "Grenade Helper", toggle = false })
    bind(s4:toggle({   name = "Enabled",    flag = "gh_on",    default = true  }), "grenade_helper_enabled")
    bind(s4:dropdown({ name = "Color Mode", flag = "gh_cmode",
        items = { "Solid", "Rainbow" }, default = "Solid" }), "grenade_color_mode")
    bind(s4:dropdown({ name = "Line Style", flag = "gh_line",
        items = { "Solid", "Dashed"  }, default = "Solid" }), "grenade_line_style")
    bindColor(s4:toggle({ name = "Trail Color",  flag = "gh_tcol_on", default = false })
        :colorpicker({ flag = "gh_tcol", color = State.colors.grenade_trail  }), "grenade_trail")
    bindColor(s4:toggle({ name = "Impact Color", flag = "gh_icol_on", default = false })
        :colorpicker({ flag = "gh_icol", color = State.colors.grenade_impact }), "grenade_impact")
end

-- ── EXPLOITS ──────────────────────────────────────────────────────────────────
do
    local colL = TabExploit:column()
    local colR = TabExploit:column()

    local s = colL:section({ name = "Weapon", toggle = false })
    bind(s:toggle({ name = "No Spread",      flag = "wx_spread",  default = false }), "weapon_no_spread")
    bind(s:toggle({ name = "No Recoil",      flag = "wx_recoil",  default = false }), "weapon_no_recoil")
    bind(s:toggle({ name = "No Sway",        flag = "wx_sway",    default = false }), "weapon_no_sway")
    bind(s:toggle({ name = "Instant ADS",    flag = "wx_ads",     default = false }), "weapon_instant_ads")
    bind(s:toggle({ name = "Rapid Fire",     flag = "wx_rf",      default = false }), "weapon_rapid_fire")
    bind(s:slider({ name = "Fire Rate Mult", flag = "wx_rfmult",  min = 1, max = 10, default = 2, interval = 0.5, suffix = "x" }), "weapon_rapid_fire_mult")
    bind(s:toggle({ name = "Extended Range", flag = "wx_range",   default = false }), "weapon_extended_range")
    bind(s:toggle({ name = "Extended Melee", flag = "wx_melee",   default = false }), "weapon_extended_melee_range")
    bind(s:slider({ name = "Melee Mult",     flag = "wx_melmult", min = 1, max = 10, default = 3, interval = 0.5, suffix = "x" }), "weapon_extended_melee_mult")

    local s2 = colR:section({ name = "Hit Feedback", toggle = false })
    bind(s2:toggle({ name = "Hit Sound",    flag = "hf_hit",   default = false }), "hit_sound_enabled")
    bind(s2:slider({ name = "Hit Volume",   flag = "hf_hvol",  min = 0, max = 2, default = 1, interval = 0.05, suffix = "x" }), "hit_sound_volume")
    bind(s2:toggle({ name = "Death Sound",  flag = "hf_death", default = false }), "death_sound_enabled")
    bind(s2:slider({ name = "Death Volume", flag = "hf_dvol",  min = 0, max = 2, default = 1, interval = 0.05, suffix = "x" }), "death_sound_volume")
    local hfx = s2:toggle({ name = "Hit Effect", flag = "hf_fx", default = false })
    bind(hfx, "hit_effect_enabled")
    bindColor(hfx:colorpicker({ flag = "hf_fxcol", color = State.colors.hit_effect }), "hit_effect")
end

-- ── PLAYERS ───────────────────────────────────────────────────────────────────
do
    local colL = TabPlayers:column()
    local colR = TabPlayers:column()

    local pl_sec  = colL:section({ name = "Playerlist", toggle = false })
    local pl_list = pl_sec:list({ flag = "pl_selected" })

    task.spawn(function()
        while library.gui and library.gui.Parent do
            if pl_list and pl_list.refresh_options then
                local self_player = players.LocalPlayer
                local names = {}
                for _, p in ipairs(players:GetPlayers()) do
                    if p ~= self_player then table.insert(names, p.Name) end
                end
                pcall(function() pl_list.refresh_options(names) end)
            end
            task.wait(3)
        end
    end)

    local act_sec = colL:section({ name = "Actions", toggle = false })

    act_sec:button({ name = "Whitelist Toggle", callback = function()
        local n = flags["pl_selected"]
        if not n or n == "" then notify("No player selected") return end
        whitelist[n] = not whitelist[n]
        notify((whitelist[n] and "Whitelisted: " or "Unwhitelisted: ") .. n)
    end })

    act_sec:button({ name = "Priority Toggle", callback = function()
        local n = flags["pl_selected"]
        if not n or n == "" then notify("No player selected") return end
        priority_list[n] = not priority_list[n]
        notify((priority_list[n] and "Priority set: " or "Priority removed: ") .. n)
    end })

    act_sec:button({ name = "Teleport To", callback = function()
        local n = flags["pl_selected"]
        if not n or n == "" then notify("No player selected") return end
        local self_char = players.LocalPlayer.Character
        local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
        if not root then notify("No character") return end
        for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
            if inst.Name == "soldier_model" then
                if inst:GetAttribute("Xenon_owner_name") == n then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        notify("Teleported to " .. n)
                        return
                    end
                end
            end
        end
        notify("Could not find " .. n)
    end })

    act_sec:button({ name = "Kill", callback = function()
        local n = flags["pl_selected"]
        if not n or n == "" then notify("No player selected") return end
        local self_char = players.LocalPlayer.Character
        local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
        if not root then notify("No character") return end
        for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
            if inst.Name == "soldier_model" then
                if inst:GetAttribute("Xenon_owner_name") == n then
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
                        notify("Killing " .. n)
                        return
                    end
                end
            end
        end
        notify("Could not find " .. n)
    end })

    local wl_sec  = colR:section({ name = "Whitelist", toggle = false })
    local wl_list = wl_sec:list({ flag = "wl_selected" })

    wl_sec:button({ name = "Remove", callback = function()
        local n = flags["wl_selected"]
        if not n or n == "" then return end
        whitelist[n] = nil
        notify("Removed: " .. n)
    end })

    task.spawn(function()
        while library.gui and library.gui.Parent do
            if wl_list and wl_list.refresh_options then
                local names = {}
                for name in pairs(whitelist) do table.insert(names, name) end
                pcall(function() wl_list.refresh_options(names) end)
            end
            task.wait(2)
        end
    end)

    getgenv().Xenon_whitelist = whitelist
    getgenv().Xenon_priority  = priority_list
end

-- ── CONFIG ────────────────────────────────────────────────────────────────────
do
    local colL = TabCfg:column()
    local colR = TabCfg:column()

    local cfg_sec  = colL:section({ name = "Configurations", toggle = false })
    local cfg_list = cfg_sec:list({ flag = "cfg_sel" })
    cfg_sec:textbox({ name = "Config Name", flag = "cfg_name", default = "" })

    local cfg_dir = library.directory .. "/configs"
    pcall(function() if not isfolder(cfg_dir) then makefolder(cfg_dir) end end)

    local function refresh_configs()
        local ok, files = pcall(listfiles, cfg_dir)
        if not ok or not files then return end
        local names = {}
        for _, f in ipairs(files) do
            local n = f:match("([^/\\]+)%.cfg$")
            if n then table.insert(names, n) end
        end
        if cfg_list and cfg_list.refresh_options then
            pcall(function() cfg_list.refresh_options(names) end)
        end
    end

    cfg_sec:button({ name = "Create", callback = function()
        local n = flags["cfg_name"]
        if not n or n == "" then notify("Enter a config name") return end
        writefile(cfg_dir .. "/" .. n .. ".cfg", library:get_config())
        refresh_configs()
        notify("Created: " .. n)
    end })

    cfg_sec:button({ name = "Save", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then notify("Select a config") return end
        writefile(cfg_dir .. "/" .. n .. ".cfg", library:get_config())
        notify("Saved: " .. n)
    end })

    cfg_sec:button({ name = "Load", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then notify("Select a config") return end
        local ok, data = pcall(readfile, cfg_dir .. "/" .. n .. ".cfg")
        if ok and data then
            library:load_config(data)
            notify("Loaded: " .. n)
        else
            notify("Failed to load: " .. n)
        end
    end })

    cfg_sec:button({ name = "Delete", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then notify("Select a config") return end
        pcall(delfile, cfg_dir .. "/" .. n .. ".cfg")
        refresh_configs()
        notify("Deleted: " .. n)
    end })

    cfg_sec:button({ name = "Refresh", callback = refresh_configs })
    refresh_configs()

    local ui_sec = colR:section({ name = "Interface", toggle = false })

    ui_sec:colorpicker({ name = "Accent Color", flag = "ui_accent",
        color = Color3.fromRGB(220, 50, 50),
        callback = function(c) library:update_theme("accent", c) end,
    })

    local menu_visible = true
    ui_sec:keybind({ name = "Toggle Menu", flag = "menu_keybind", callback = function()
        menu_visible = not menu_visible
        pcall(function() window.set_menu_visibility(menu_visible) end)
    end })

    ui_sec:button({ name = "Unload", callback = function()
        notify("Unloading xenon...")
        task.delay(0.5, function()
            pcall(getgenv().run_all_cleanup)
            pcall(getgenv().Xenon_AimStop)
            pcall(function()
                if library.gui then library.gui:Destroy() end
            end)
        end)
    end })
end

-- set grenade helper on by default after flags initialise
task.defer(function()
    State.flags.grenade_helper_enabled = true
    pcall(getgenv().Xenon_AimSync)
end)
