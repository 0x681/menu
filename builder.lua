local library, notifications, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/0x681/menu/refs/heads/main/1.lua"))()

local State         = getgenv().State
local players       = game:GetService("Players")
local flags         = library.flags

local whitelist = {}
local priority_list = {}

local function bind(elem, key, transform)
    if not elem then return end
    local cb = elem.callback
    elem.callback = function(v)
        State.flags[key] = transform and transform(v) or v
        if cb then cb(v) end
        pcall(getgenv().Xenon_AimSync)
    end
    task.defer(function()
        if flags[elem.flag] ~= nil then
            State.flags[key] = transform and transform(flags[elem.flag]) or flags[elem.flag]
        end
    end)
    return elem
end

local function bindColor(elem, key)
    if not elem then return end
    local cb = elem.callback
    elem.callback = function(c, a)
        State.colors[key] = c
        if cb then cb(c, a) end
    end
    return elem
end

local window = library:window({
    name = '<font color="rgb(220,50,50)">xenon</font>  |  frontlines',
    size = UDim2.new(0, 570, 0, 620),
})

local TabESP     = window:tab({ name = "ESP"      })
local TabAim     = window:tab({ name = "Aim"      })
local TabChams   = window:tab({ name = "Chams"    })
local TabVisuals = window:tab({ name = "Visuals"  })
local TabExploit = window:tab({ name = "Exploits" })
local TabPlayers = window:tab({ name = "Players"  })
local TabCfg     = window:tab({ name = "Config"   })

do
    local L = TabESP:column({})
    local R = TabESP:column({})

    local s = L:section({ name = "Players" })
    bind(s:addToggle({ name = "Box ESP",        flag = "e_box",        default = false }), "esp_box")
    bind(s:addToggle({ name = "Name",           flag = "e_name",       default = false }), "esp_name")
    bind(s:addToggle({ name = "Distance",       flag = "e_dist",       default = false }), "esp_distance")
    bind(s:addToggle({ name = "Health Bar",     flag = "e_hp",         default = false }), "esp_healthbar")
    bind(s:addToggle({ name = "Held Item",      flag = "e_item",       default = false }), "esp_held_item")
    bind(s:addToggle({ name = "Team Colors",    flag = "e_team",       default = false }), "esp_team_color")
    bind(s:addToggle({ name = "Hide Teammates", flag = "e_hidefriend", default = false }), "esp_hide_friendly")
    bind(s:addToggle({ name = "Dead Check",     flag = "e_dead",       default = false }), "esp_dead_check")
    bind(s:addSlider({ name = "Dead Radius",    flag = "e_deadrad",    min=1,   max=20,   default=3,    interval=1,  suffix="st" }), "esp_dead_radius")
    bind(s:addSlider({ name = "Max Distance",   flag = "e_maxdist",    min=100, max=5000, default=2000, interval=50, suffix="st" }), "esp_max_distance")

    local cs = R:section({ name = "Colors" })
    bindColor(cs:addLabel({ name = "Enemy"    }):addColorPicker({ flag = "ec_enemy",  color = State.colors.esp_enemy     }), "esp_enemy")
    bindColor(cs:addLabel({ name = "Friendly" }):addColorPicker({ flag = "ec_friend", color = State.colors.esp_friendly  }), "esp_friendly")
    bindColor(cs:addLabel({ name = "Distance" }):addColorPicker({ flag = "ec_dist",   color = State.colors.esp_distance  }), "esp_distance")
    bindColor(cs:addLabel({ name = "Dead"     }):addColorPicker({ flag = "ec_dead",   color = State.colors.esp_dead      }), "esp_dead")
    bindColor(cs:addLabel({ name = "Health"   }):addColorPicker({ flag = "ec_hp",     color = State.colors.esp_healthbar }), "esp_healthbar")
end

do
    local L = TabAim:column({})
    local R = TabAim:column({})

    local s = L:section({ name = "Silent Aim" })
    bind(s:addToggle({ name = "Enabled",       flag = "sa_on",     default = false }), "silent_aim_enabled")
    bind(s:addSlider({ name = "FOV",           flag = "sa_fov",    min=1, max=360, default=180, interval=1, suffix="°" }), "silent_aim_fov")
    bind(s:addSlider({ name = "Hit Chance",    flag = "sa_chance", min=1, max=100, default=100, interval=1, suffix="%" }), "silent_aim_hit_chance")
    bind(s:addToggle({ name = "Show FOV Ring", flag = "sa_ring",   default = false }), "silent_aim_show_fov")
    bindColor(s:addLabel({ name = "FOV Ring Color" }):addColorPicker({ flag = "sa_ringcol", color = State.colors.fov_circle }), "fov_circle")
    bind(s:addDropdown({ name = "Hitbox", flag = "sa_hitbox",
        items = { "Head","HumanoidRootPart","UpperTorso","LowerTorso" },
        default = "Head",
    }), "silent_aim_hitbox")

    local s2 = R:section({ name = "Combat" })
    bind(s2:addToggle({ name = "Kill Aura",   flag = "ka_on",    default = false }), "kill_aura_enabled")
    bind(s2:addSlider({ name = "Aura Range",  flag = "ka_range", min=5, max=60, default=12, interval=1, suffix="st" }), "kill_aura_range")
    bind(s2:addToggle({ name = "Auto Shoot",  flag = "as_on",    default = false }), "auto_shoot_enabled")
    bind(s2:addToggle({ name = "Auto Reload", flag = "ar_on",    default = false }), "auto_reload_enabled")
end

do
    local L = TabChams:column({})
    local R = TabChams:column({})

    local s = L:section({ name = "Player Chams" })
    bind(s:addToggle({   name = "Enabled",  flag = "pc_on",  default = false }), "chams")
    bind(s:addDropdown({ name = "Material", flag = "pc_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = "Neon" }), "chams_material")
    bind(s:addToggle({   name = "Rainbow",  flag = "pc_rb",  default = false }), "chams_rainbow")
    bindColor(s:addLabel({ name = "Enemy Color"    }):addColorPicker({ flag = "pc_ecol", color = State.colors.chams_enemy    }), "chams_enemy")
    bindColor(s:addLabel({ name = "Friendly Color" }):addColorPicker({ flag = "pc_fcol", color = State.colors.chams_friendly }), "chams_friendly")

    local s2 = R:section({ name = "Viewmodel Chams" })
    bind(s2:addToggle({   name = "Enabled",  flag = "vc_on",  default = false }), "viewmodel_chams")
    bind(s2:addDropdown({ name = "Material", flag = "vc_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = "Neon" }), "viewmodel_chams_material")
    bind(s2:addToggle({   name = "Rainbow",  flag = "vc_rb",  default = false }), "viewmodel_chams_rainbow")
    bindColor(s2:addLabel({ name = "Color" }):addColorPicker({ flag = "vc_col", color = State.colors.viewmodel_chams }), "viewmodel_chams")

    local s3 = R:section({ name = "Gun Chams" })
    bind(s3:addToggle({   name = "Enabled",        flag = "gc_on",     default = false }), "gun_material_enabled")
    bind(s3:addDropdown({ name = "Material",       flag = "gc_mat",    items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = "Neon" }), "gun_material")
    bind(s3:addToggle({   name = "Rainbow",        flag = "gc_rb",     default = false }), "gun_color_rainbow")
    bind(s3:addToggle({   name = "Color Override", flag = "gc_col_on", default = false }), "gun_color_override")
    bindColor(s3:addLabel({ name = "Color"         }):addColorPicker({ flag = "gc_col",     color = State.colors.gun_color         }), "gun_color")
    bind(s3:addToggle({   name = "Outline",        flag = "gc_out_on", default = false }), "gun_outline_enabled")
    bindColor(s3:addLabel({ name = "Outline Color" }):addColorPicker({ flag = "gc_out_col", color = State.colors.gun_outline_color }), "gun_outline_color")
end

do
    local L = TabVisuals:column({})
    local R = TabVisuals:column({})

    local s = L:section({ name = "World Chams" })
    bind(s:addToggle({   name = "Enabled",       flag = "wc_on",     default = false }), "world_chams")
    bind(s:addDropdown({ name = "Mode",          flag = "wc_mode",   items = { "Fade","Solid" }, default = "Fade" }), "world_chams_mode")
    bind(s:addSlider({   name = "Range",         flag = "wc_range",  min=20, max=800, default=200, interval=10, suffix="st" }), "world_chams_range")
    bind(s:addSlider({   name = "Transparency",  flag = "wc_tr",     min=0,  max=95,  default=60,  interval=5,  suffix="%" }), "world_chams_transparency", function(v) return v/100 end)
    bind(s:addDropdown({ name = "Material",      flag = "wc_mat",    items = { "Glass","Neon","ForceField","SmoothPlastic" }, default = "Glass" }), "world_chams_material")
    bind(s:addToggle({   name = "Color Override",flag = "wc_col_on", default = false }), "world_chams_color_override")
    bindColor(s:addLabel({ name = "Color" }):addColorPicker({ flag = "wc_col", color = State.colors.world_chams_color }), "world_chams_color")

    local s2 = R:section({ name = "Lighting" })
    bind(s2:addToggle({ name = "No Fog",            flag = "w_nofog",  default = false }), "no_fog")
    bind(s2:addToggle({ name = "Bright Lighting",   flag = "w_bright", default = false }), "bright_lighting")
    bind(s2:addToggle({ name = "No Atmosphere",     flag = "w_noatm",  default = false }), "no_atmosphere")
    bind(s2:addToggle({ name = "No Depth of Field", flag = "w_nodof",  default = false }), "no_depth_of_field")
    bind(s2:addToggle({ name = "No Damage Blur",    flag = "w_noblur", default = false }), "no_damage_blur")
    bind(s2:addToggle({ name = "Night Vision",      flag = "w_nv",     default = false }), "night_vision")
    bindColor(s2:addLabel({ name = "NV Tint"     }):addColorPicker({ flag = "w_nvcol", color = State.colors.night_vision_tint }), "night_vision_tint")
    bind(s2:addToggle({ name = "Thermal Vision",    flag = "w_tv",     default = false }), "thermal_vision")
    bindColor(s2:addLabel({ name = "Thermal Tint"  }):addColorPicker({ flag = "w_tvcol", color = State.colors.thermal_tint }), "thermal_tint")

    local s3 = R:section({ name = "Tracers" })
    bind(s3:addToggle({   name = "Enabled",  flag = "tr_on",  default = false }), "custom_tracers_enabled")
    bind(s3:addDropdown({ name = "Material", flag = "tr_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = "Neon" }), "tracer_material")
    bind(s3:addToggle({   name = "Rainbow",  flag = "tr_rb",  default = false }), "tracer_rainbow")
    bindColor(s3:addLabel({ name = "Color" }):addColorPicker({ flag = "tr_col", color = State.colors.tracer_color }), "tracer_color")

    local s4 = R:section({ name = "Grenade Helper" })
    bind(s4:addToggle({   name = "Enabled",    flag = "gh_on",    default = true }), "grenade_helper_enabled")
    bind(s4:addDropdown({ name = "Color Mode", flag = "gh_cmode", items = { "Solid","Rainbow" }, default = "Solid" }), "grenade_color_mode")
    bind(s4:addDropdown({ name = "Line Style", flag = "gh_line",  items = { "Solid","Dashed"  }, default = "Solid" }), "grenade_line_style")
    bindColor(s4:addLabel({ name = "Trail Color"  }):addColorPicker({ flag = "gh_tcol", color = State.colors.grenade_trail  }), "grenade_trail")
    bindColor(s4:addLabel({ name = "Impact Color" }):addColorPicker({ flag = "gh_icol", color = State.colors.grenade_impact }), "grenade_impact")
end

do
    local L = TabExploit:column({})
    local R = TabExploit:column({})

    local s = L:section({ name = "Weapon" })
    bind(s:addToggle({ name = "No Spread",      flag = "wx_spread",  default = false }), "weapon_no_spread")
    bind(s:addToggle({ name = "No Recoil",      flag = "wx_recoil",  default = false }), "weapon_no_recoil")
    bind(s:addToggle({ name = "No Sway",        flag = "wx_sway",    default = false }), "weapon_no_sway")
    bind(s:addToggle({ name = "Instant ADS",    flag = "wx_ads",     default = false }), "weapon_instant_ads")
    bind(s:addToggle({ name = "Rapid Fire",     flag = "wx_rf",      default = false }), "weapon_rapid_fire")
    bind(s:addSlider({ name = "Fire Rate",      flag = "wx_rfmult",  min=1, max=10, default=2, interval=0.5, suffix="x" }), "weapon_rapid_fire_mult")
    bind(s:addToggle({ name = "Extended Range", flag = "wx_range",   default = false }), "weapon_extended_range")
    bind(s:addToggle({ name = "Extended Melee", flag = "wx_melee",   default = false }), "weapon_extended_melee_range")
    bind(s:addSlider({ name = "Melee Mult",     flag = "wx_melmult", min=1, max=10, default=3, interval=0.5, suffix="x" }), "weapon_extended_melee_mult")

    local s2 = R:section({ name = "Hit Feedback" })
    bind(s2:addToggle({ name = "Hit Sound",           flag = "hf_hit",   default = false }), "hit_sound_enabled")
    bind(s2:addSlider({ name = "Hit Volume",          flag = "hf_hvol",  min=0, max=2, default=1, interval=0.05, suffix="x" }), "hit_sound_volume")
    bind(s2:addToggle({ name = "Death Sound",         flag = "hf_death", default = false }), "death_sound_enabled")
    bind(s2:addSlider({ name = "Death Volume",        flag = "hf_dvol",  min=0, max=2, default=1, interval=0.05, suffix="x" }), "death_sound_volume")
    bind(s2:addToggle({ name = "Hit Effect (screen)", flag = "hf_fx",    default = false }), "hit_effect_enabled")
    bindColor(s2:addLabel({ name = "Hit Effect Color" }):addColorPicker({ flag = "hf_fxcol", color = State.colors.hit_effect }), "hit_effect")
end

do
    local L = TabPlayers:column({})
    local R = TabPlayers:column({})

    -- Playerlist
    local pl_section = L:section({ name = "Playerlist" })
    local pl_list = pl_section:addList({ name = "Players", flag = "pl_selected", scale = 120 })

    local selected_name = nil
    if pl_list then
        local orig_cb = pl_list.callback
        pl_list.callback = function(v)
            selected_name = v
            if orig_cb then orig_cb(v) end
        end
    end

    task.spawn(function()
        while library.gui and library.gui.Parent do
            if pl_list and pl_list.refresh_options then
                local names = {}
                local self_player = players.LocalPlayer
                for _, p in ipairs(players:GetPlayers()) do
                    if p ~= self_player then
                        table.insert(names, p.Name)
                    end
                end
                pcall(function() pl_list.refresh_options(names) end)
            end
            task.wait(3)
        end
    end)

    local acts = L:section({ name = "Actions" })

    acts:addButton({ name = "Whitelist", callback = function()
        local n = selected_name or flags["pl_selected"]
        if not n or n == "" then return end
        whitelist[n] = not whitelist[n]
        notifications:create_notification({ name = (whitelist[n] and "Whitelisted: " or "Unwhitelisted: ") .. n })
    end })

    acts:addButton({ name = "Priority", callback = function()
        local n = selected_name or flags["pl_selected"]
        if not n or n == "" then return end
        priority_list[n] = not priority_list[n]
        notifications:create_notification({ name = (priority_list[n] and "Priority set: " or "Priority removed: ") .. n })
    end })

    acts:addButton({ name = "Teleport To", callback = function()
        local n = selected_name or flags["pl_selected"]
        if not n or n == "" then return end
        local lp = players.LocalPlayer
        local target = players:FindFirstChild(n)
        local self_char = lp.Character
        local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        -- find target soldier model
        for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
            if inst.Name == "soldier_model" then
                local attr = pcall(function() return inst:GetAttribute("Xenon_owner_name") end)
                -- try by attribute or friendly_marker
                local owner = inst:GetAttribute("Xenon_owner_name")
                if owner == n then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        root.CFrame = hrp.CFrame + Vector3.new(0, 3, 0)
                        notifications:create_notification({ name = "Teleported to " .. n })
                        return
                    end
                end
            end
        end
        notifications:create_notification({ name = "Could not find " .. n })
    end })

    acts:addButton({ name = "Kill", callback = function()
        local n = selected_name or flags["pl_selected"]
        if not n or n == "" then return end
        local lp = players.LocalPlayer
        local self_char = lp.Character
        local root = self_char and self_char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        -- find target
        for _, inst in ipairs(game:GetService("Workspace"):GetChildren()) do
            if inst.Name == "soldier_model" then
                local owner = inst:GetAttribute("Xenon_owner_name")
                if owner == n then
                    local hrp = inst:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        -- tp behind them, enable auto shoot briefly
                        local behind = hrp.CFrame * CFrame.new(0, 1, 2)
                        root.CFrame = behind
                        local prev = State.flags.auto_shoot_enabled
                        State.flags.auto_shoot_enabled = true
                        pcall(getgenv().Xenon_AimSync)
                        task.delay(1.5, function()
                            State.flags.auto_shoot_enabled = prev
                            pcall(getgenv().Xenon_AimSync)
                        end)
                        notifications:create_notification({ name = "Killing " .. n })
                        return
                    end
                end
            end
        end
        notifications:create_notification({ name = "Could not find " .. n })
    end })

    -- Whitelist display
    local wl_section = R:section({ name = "Whitelist" })
    local wl_list = wl_section:addList({ name = "Whitelisted", flag = "wl_selected", scale = 80 })

    wl_section:addButton({ name = "Remove Selected", callback = function()
        local n = flags["wl_selected"]
        if not n or n == "" then return end
        whitelist[n] = nil
        notifications:create_notification({ name = "Removed from whitelist: " .. n })
    end })

    -- Keep whitelist display in sync and expose to ESP
    task.spawn(function()
        while library.gui and library.gui.Parent do
            if wl_list and wl_list.refresh_options then
                local names = {}
                for name in pairs(whitelist) do
                    table.insert(names, name)
                end
                pcall(function() wl_list.refresh_options(names) end)
            end
            task.wait(2)
        end
    end)

    getgenv().Xenon_whitelist = whitelist
    getgenv().Xenon_priority  = priority_list
end

do
    local L = TabCfg:column({})
    local R = TabCfg:column({})

    local s = L:section({ name = "Configurations" })
    local cfg_list = s:addList({ name = "Options", flag = "cfg_sel", scale = 120 })
    s:addTextBox({ name = "Config Name", flag = "cfg_name", default = "" })

    local function refresh_configs()
        local ok, files = pcall(listfiles, library.directory .. "/configs")
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

    s:addButton({ name = "Create", callback = function()
        local n = flags["cfg_name"]
        if not n or n == "" then return end
        writefile(library.directory .. "/configs/" .. n .. ".cfg", library:getConfig())
        refresh_configs()
        notifications:create_notification({ name = "Created: " .. n })
    end })
    s:addButton({ name = "Delete", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        pcall(delfile, library.directory .. "/configs/" .. n .. ".cfg")
        refresh_configs()
    end })
    s:addButton({ name = "Load", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        local ok, d = pcall(readfile, library.directory .. "/configs/" .. n .. ".cfg")
        if ok then
            library:loadConfig(d)
            notifications:create_notification({ name = "Loaded: " .. n })
        end
    end })
    s:addButton({ name = "Save", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        writefile(library.directory .. "/configs/" .. n .. ".cfg", library:getConfig())
        notifications:create_notification({ name = "Saved: " .. n })
    end })
    s:addButton({ name = "Refresh", callback = refresh_configs })
    refresh_configs()

    local s2 = R:section({ name = "Interface" })
    s2:addLabel({ name = "Accent Color" }):addColorPicker({
        flag = "ui_accent", color = themes.preset.accent,
        callback = function(c) library:updateTheme("accent", c) end,
    })
    local menu_open = true
    s2:addLabel({ name = "Menu Keybind" }):addKeyBind({
        flag = "menu_keybind",
        callback = function()
            if not window.is_closing_menu then
                menu_open = not menu_open
                window.toggle_menu(menu_open)
            end
        end,
    })
    s2:addButton({ name = "Unload Menu", callback = function()
        notifications:create_notification({ name = "Unloading xenon..." })
        task.delay(0.5, function()
            library:unloadMenu()
            pcall(getgenv().run_all_cleanup)
            pcall(getgenv().Xenon_AimStop)
        end)
    end })
end

notifications:create_notification({ name = '<font color="rgb(220,50,50)">xenon</font>  loaded' })
