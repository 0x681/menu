local library, notifications, themes = loadstring(game:HttpGet("https://raw.githubusercontent.com/0x681/menu/refs/heads/main/1.lua"))()

local State   = getgenv().State
local players = game:GetService("Players")
local flags   = library.flags

local function bind(elem, key, transform)
    if not elem then return end
    local cb = elem.callback
    elem.callback = function(v)
        State.flags[key] = transform and transform(v) or v
        if cb then cb(v) end
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

-- ESP
do
    local L = TabESP:column({})
    local R = TabESP:column({})

    local s = L:section({ name = "Players" })
    local t = bind(s:addToggle({ name = "Box ESP",        flag = "e_box",        default = State.flags.esp_box           }), "esp_box")
    local t = bind(s:addToggle({ name = "Name",           flag = "e_name",       default = State.flags.esp_name          }), "esp_name")
    local t = bind(s:addToggle({ name = "Distance",       flag = "e_dist",       default = State.flags.esp_distance      }), "esp_distance")
    local t = bind(s:addToggle({ name = "Health Bar",     flag = "e_hp",         default = State.flags.esp_healthbar     }), "esp_healthbar")
    local t = bind(s:addToggle({ name = "Held Item",      flag = "e_item",       default = State.flags.esp_held_item     }), "esp_held_item")
    local t = bind(s:addToggle({ name = "Team Colors",    flag = "e_team",       default = State.flags.esp_team_color    }), "esp_team_color")
    bind(s:addToggle({ name = "Hide Teammates",            flag = "e_hidefriend", default = State.flags.esp_hide_friendly }), "esp_hide_friendly")
    bind(s:addToggle({ name = "Dead Check",                flag = "e_dead",       default = State.flags.esp_dead_check    }), "esp_dead_check")
    bind(s:addSlider({ name = "Dead Radius",               flag = "e_deadrad",    min=1,   max=20,   default=State.flags.esp_dead_radius,  interval=1,  suffix="st" }), "esp_dead_radius")
    bind(s:addSlider({ name = "Max Distance",              flag = "e_maxdist",    min=100, max=5000, default=State.flags.esp_max_distance, interval=50, suffix="st" }), "esp_max_distance")

    local cs = R:section({ name = "Colors" })
    bindColor(cs:addLabel({ name = "Enemy"    }):addColorPicker({ flag = "ec_enemy",  color = State.colors.esp_enemy     }), "esp_enemy")
    bindColor(cs:addLabel({ name = "Friendly" }):addColorPicker({ flag = "ec_friend", color = State.colors.esp_friendly  }), "esp_friendly")
    bindColor(cs:addLabel({ name = "Distance" }):addColorPicker({ flag = "ec_dist",   color = State.colors.esp_distance  }), "esp_distance")
    bindColor(cs:addLabel({ name = "Dead"     }):addColorPicker({ flag = "ec_dead",   color = State.colors.esp_dead      }), "esp_dead")
    bindColor(cs:addLabel({ name = "Health"   }):addColorPicker({ flag = "ec_hp",     color = State.colors.esp_healthbar }), "esp_healthbar")
end

-- Aim
do
    local L = TabAim:column({})
    local R = TabAim:column({})

    local s = L:section({ name = "Silent Aim" })
    bind(s:addToggle({ name = "Enabled",       flag = "sa_on",     default = State.flags.silent_aim_enabled    }), "silent_aim_enabled")
    bind(s:addSlider({ name = "FOV",           flag = "sa_fov",    min=1, max=360, default=State.flags.silent_aim_fov,       interval=1, suffix="°" }), "silent_aim_fov")
    bind(s:addSlider({ name = "Hit Chance",    flag = "sa_chance", min=1, max=100, default=State.flags.silent_aim_hit_chance, interval=1, suffix="%" }), "silent_aim_hit_chance")
    bind(s:addToggle({ name = "Show FOV Ring", flag = "sa_ring",   default = State.flags.silent_aim_show_fov   }), "silent_aim_show_fov")
    bindColor(s:addLabel({ name = "FOV Ring Color" }):addColorPicker({ flag = "sa_ringcol", color = State.colors.fov_circle }), "fov_circle")
    bind(s:addDropdown({ name = "Hitbox", flag = "sa_hitbox",
        items = { "Head","HumanoidRootPart","UpperTorso","LowerTorso" },
        default = State.flags.silent_aim_hitbox,
    }), "silent_aim_hitbox")

    local s2 = R:section({ name = "Combat" })
    bind(s2:addToggle({ name = "Kill Aura",   flag = "ka_on",    default = State.flags.kill_aura_enabled   }), "kill_aura_enabled")
    bind(s2:addSlider({ name = "Aura Range",  flag = "ka_range", min=5, max=60, default=State.flags.kill_aura_range, interval=1, suffix="st" }), "kill_aura_range")
    bind(s2:addToggle({ name = "Auto Shoot",  flag = "as_on",    default = State.flags.auto_shoot_enabled  }), "auto_shoot_enabled")
    bind(s2:addToggle({ name = "Auto Reload", flag = "ar_on",    default = State.flags.auto_reload_enabled }), "auto_reload_enabled")
end

-- Chams: Player Chams (L) | Viewmodel + Gun Chams (R)
do
    local L = TabChams:column({})
    local R = TabChams:column({})

    local s = L:section({ name = "Player Chams" })
    bind(s:addToggle({ name = "Enabled",  flag = "pc_on",  default = State.flags.chams         }), "chams")
    bind(s:addDropdown({ name = "Material", flag = "pc_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = State.flags.chams_material }), "chams_material")
    bind(s:addToggle({ name = "Rainbow",  flag = "pc_rb",  default = State.flags.chams_rainbow }), "chams_rainbow")
    bindColor(s:addLabel({ name = "Enemy Color"    }):addColorPicker({ flag = "pc_ecol", color = State.colors.chams_enemy    }), "chams_enemy")
    bindColor(s:addLabel({ name = "Friendly Color" }):addColorPicker({ flag = "pc_fcol", color = State.colors.chams_friendly }), "chams_friendly")

    local s2 = R:section({ name = "Viewmodel Chams" })
    bind(s2:addToggle({ name = "Enabled",  flag = "vc_on",  default = State.flags.viewmodel_chams         }), "viewmodel_chams")
    bind(s2:addDropdown({ name = "Material", flag = "vc_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = State.flags.viewmodel_chams_material }), "viewmodel_chams_material")
    bind(s2:addToggle({ name = "Rainbow",  flag = "vc_rb",  default = State.flags.viewmodel_chams_rainbow }), "viewmodel_chams_rainbow")
    bindColor(s2:addLabel({ name = "Color" }):addColorPicker({ flag = "vc_col", color = State.colors.viewmodel_chams }), "viewmodel_chams")

    -- Gun chams under same right column
    local s3 = R:section({ name = "Gun Chams" })
    bind(s3:addToggle({  name = "Enabled",        flag = "gc_on",     default = State.flags.gun_material_enabled }), "gun_material_enabled")
    bind(s3:addDropdown({ name = "Material",      flag = "gc_mat",    items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = State.flags.gun_material }), "gun_material")
    bind(s3:addToggle({  name = "Rainbow",        flag = "gc_rb",     default = State.flags.gun_color_rainbow    }), "gun_color_rainbow")
    bind(s3:addToggle({  name = "Color Override", flag = "gc_col_on", default = State.flags.gun_color_override   }), "gun_color_override")
    bindColor(s3:addLabel({ name = "Color"         }):addColorPicker({ flag = "gc_col",     color = State.colors.gun_color         }), "gun_color")
    bind(s3:addToggle({  name = "Outline",        flag = "gc_out_on", default = State.flags.gun_outline_enabled  }), "gun_outline_enabled")
    bindColor(s3:addLabel({ name = "Outline Color" }):addColorPicker({ flag = "gc_out_col", color = State.colors.gun_outline_color }), "gun_outline_color")
end

-- Visuals: World Chams (L) | Lighting + Tracers + Grenade (R)
do
    local L = TabVisuals:column({})
    local R = TabVisuals:column({})

    local s = L:section({ name = "World Chams" })
    bind(s:addToggle({  name = "Enabled",       flag = "wc_on",     default = State.flags.world_chams              }), "world_chams")
    bind(s:addDropdown({ name = "Mode",         flag = "wc_mode",   items = { "Fade","Solid" }, default = State.flags.world_chams_mode }), "world_chams_mode")
    bind(s:addSlider({  name = "Range",         flag = "wc_range",  min=20, max=800, default=State.flags.world_chams_range, interval=10, suffix="st" }), "world_chams_range")
    bind(s:addSlider({  name = "Transparency",  flag = "wc_tr",     min=0,  max=95,  default=math.floor(State.flags.world_chams_transparency*100), interval=5, suffix="%" }), "world_chams_transparency", function(v) return v/100 end)
    bind(s:addDropdown({ name = "Material",     flag = "wc_mat",    items = { "Glass","Neon","ForceField","SmoothPlastic" }, default = State.flags.world_chams_material }), "world_chams_material")
    bind(s:addToggle({  name = "Color Override",flag = "wc_col_on", default = State.flags.world_chams_color_override }), "world_chams_color_override")
    bindColor(s:addLabel({ name = "Color" }):addColorPicker({ flag = "wc_col", color = State.colors.world_chams_color }), "world_chams_color")

    local s2 = R:section({ name = "Lighting" })
    bind(s2:addToggle({ name = "No Fog",            flag = "w_nofog",  default = State.flags.no_fog            }), "no_fog")
    bind(s2:addToggle({ name = "Bright Lighting",   flag = "w_bright", default = State.flags.bright_lighting   }), "bright_lighting")
    bind(s2:addToggle({ name = "No Atmosphere",     flag = "w_noatm",  default = State.flags.no_atmosphere     }), "no_atmosphere")
    bind(s2:addToggle({ name = "No Depth of Field", flag = "w_nodof",  default = State.flags.no_depth_of_field }), "no_depth_of_field")
    bind(s2:addToggle({ name = "No Damage Blur",    flag = "w_noblur", default = State.flags.no_damage_blur    }), "no_damage_blur")
    bind(s2:addToggle({ name = "Night Vision",      flag = "w_nv",     default = State.flags.night_vision      }), "night_vision")
    bindColor(s2:addLabel({ name = "NV Tint"      }):addColorPicker({ flag = "w_nvcol", color = State.colors.night_vision_tint }), "night_vision_tint")
    bind(s2:addToggle({ name = "Thermal Vision",    flag = "w_tv",     default = State.flags.thermal_vision    }), "thermal_vision")
    bindColor(s2:addLabel({ name = "Thermal Tint"  }):addColorPicker({ flag = "w_tvcol", color = State.colors.thermal_tint      }), "thermal_tint")
    -- Tracers inline in Lighting section
    bind(s2:addToggle({  name = "Custom Tracers", flag = "tr_on",  default = State.flags.custom_tracers_enabled }), "custom_tracers_enabled")
    bind(s2:addDropdown({ name = "Tracer Material", flag = "tr_mat", items = { "Neon","Glass","ForceField","SmoothPlastic" }, default = State.flags.tracer_material }), "tracer_material")
    bind(s2:addToggle({  name = "Tracer Rainbow",   flag = "tr_rb",  default = State.flags.tracer_rainbow         }), "tracer_rainbow")
    bindColor(s2:addLabel({ name = "Tracer Color" }):addColorPicker({ flag = "tr_col", color = State.colors.tracer_color }), "tracer_color")

    local s3 = R:section({ name = "Grenade Helper" })
    bind(s3:addToggle({  name = "Enabled",    flag = "gh_on",    default = State.flags.grenade_helper_enabled }), "grenade_helper_enabled")
    bind(s3:addDropdown({ name = "Color Mode",flag = "gh_cmode", items = { "Solid","Rainbow" }, default = State.flags.grenade_color_mode }), "grenade_color_mode")
    bind(s3:addDropdown({ name = "Line Style",flag = "gh_line",  items = { "Solid","Dashed"  }, default = State.flags.grenade_line_style }), "grenade_line_style")
    bindColor(s3:addLabel({ name = "Trail Color"  }):addColorPicker({ flag = "gh_tcol", color = State.colors.grenade_trail  }), "grenade_trail")
    bindColor(s3:addLabel({ name = "Impact Color" }):addColorPicker({ flag = "gh_icol", color = State.colors.grenade_impact }), "grenade_impact")
end

-- Exploits
do
    local L = TabExploit:column({})
    local R = TabExploit:column({})

    local s = L:section({ name = "Weapon" })
    bind(s:addToggle({ name = "No Spread",      flag = "wx_spread",  default = State.flags.weapon_no_spread            }), "weapon_no_spread")
    bind(s:addToggle({ name = "No Recoil",      flag = "wx_recoil",  default = State.flags.weapon_no_recoil            }), "weapon_no_recoil")
    bind(s:addToggle({ name = "No Sway",        flag = "wx_sway",    default = State.flags.weapon_no_sway              }), "weapon_no_sway")
    bind(s:addToggle({ name = "Instant ADS",    flag = "wx_ads",     default = State.flags.weapon_instant_ads          }), "weapon_instant_ads")
    bind(s:addToggle({ name = "Rapid Fire",     flag = "wx_rf",      default = State.flags.weapon_rapid_fire           }), "weapon_rapid_fire")
    bind(s:addSlider({ name = "Fire Rate",      flag = "wx_rfmult",  min=1, max=10, default=State.flags.weapon_rapid_fire_mult,     interval=0.5, suffix="x" }), "weapon_rapid_fire_mult")
    bind(s:addToggle({ name = "Extended Range", flag = "wx_range",   default = State.flags.weapon_extended_range       }), "weapon_extended_range")
    bind(s:addToggle({ name = "Extended Melee", flag = "wx_melee",   default = State.flags.weapon_extended_melee_range }), "weapon_extended_melee_range")
    bind(s:addSlider({ name = "Melee Mult",     flag = "wx_melmult", min=1, max=10, default=State.flags.weapon_extended_melee_mult, interval=0.5, suffix="x" }), "weapon_extended_melee_mult")

    local s2 = R:section({ name = "Hit Feedback" })
    bind(s2:addToggle({ name = "Hit Sound",           flag = "hf_hit",   default = State.flags.hit_sound_enabled   }), "hit_sound_enabled")
    bind(s2:addSlider({ name = "Hit Volume",          flag = "hf_hvol",  min=0, max=2, default=State.flags.hit_sound_volume,   interval=0.05, suffix="x" }), "hit_sound_volume")
    bind(s2:addToggle({ name = "Death Sound",         flag = "hf_death", default = State.flags.death_sound_enabled }), "death_sound_enabled")
    bind(s2:addSlider({ name = "Death Volume",        flag = "hf_dvol",  min=0, max=2, default=State.flags.death_sound_volume, interval=0.05, suffix="x" }), "death_sound_volume")
    bind(s2:addToggle({ name = "Hit Effect (screen)", flag = "hf_fx",    default = State.flags.hit_effect_enabled  }), "hit_effect_enabled")
    bindColor(s2:addLabel({ name = "Hit Effect Color" }):addColorPicker({ flag = "hf_fxcol", color = State.colors.hit_effect }), "hit_effect")
end

-- Players tab: Playerlist
do
    local L = TabPlayers:column({})

    local pl_section = L:section({ name = "Playerlist" })
    local pl_list = pl_section:addList({ name = "Players", flag = "pl_selected", scale = 120 })

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
end

-- Config
do
    local L = TabCfg:column({})
    local R = TabCfg:column({})

    local s = L:section({ name = "Configurations" })
    s:addList({ name = "Options", flag = "cfg_sel", scale = 160 })
    s:addTextBox({ name = "Config Name", flag = "cfg_name", default = "" })
    s:addButton({ name = "Create", callback = function()
        local n = flags["cfg_name"]
        if not n or n == "" then return end
        writefile(library.directory .. "/configs/" .. n .. ".cfg", library:getConfig())
        library:configListUpdate()
        notifications:create_notification({ name = "Created: " .. n })
    end })
    s:addButton({ name = "Delete", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        pcall(delfile, library.directory .. "/configs/" .. n .. ".cfg")
        library:configListUpdate()
    end })
    s:addButton({ name = "Load", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        local ok, d = pcall(readfile, library.directory .. "/configs/" .. n .. ".cfg")
        if ok then library:loadConfig(d) end
    end })
    s:addButton({ name = "Save", callback = function()
        local n = flags["cfg_sel"]
        if not n or n == "" then return end
        writefile(library.directory .. "/configs/" .. n .. ".cfg", library:getConfig())
        notifications:create_notification({ name = "Saved: " .. n })
    end })
    s:addButton({ name = "Refresh Configs", callback = function()
        library:configListUpdate()
    end })
    library:configListUpdate()

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
    s2:addButton({ name = "Unload Config", callback = function()
        notifications:create_notification({ name = "Config unloaded" })
    end })
    s2:addButton({ name = "Unload Menu", callback = function()
        notifications:create_notification({ name = "Unloading xenon..." })
        task.delay(0.5, function()
            library:unloadMenu()
            pcall(run_all_cleanup)
        end)
    end })
end

notifications:create_notification({ name = '<font color="rgb(220,50,50)">xenon</font>  loaded' })
