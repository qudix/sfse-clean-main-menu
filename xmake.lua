-- set minimum xmake version
set_xmakever("2.8.2")

-- add custom package repository
includes("lib/commonlibsf")

-- set project
set_project("sfse-clean-main-menu")
set_version("0.3.0")
set_license("GPL-3.0")

-- set defaults
set_languages("c++23")
set_warnings("allextra")
set_defaultmode("releasedbg")

-- add rules
add_rules("mode.releasedbg", "mode.debug")
add_rules("plugin.vsxmake.autoupdate")

-- set policies
set_policy("package.requires_lock", true)

-- require package dependencies
add_requires("toml++")

-- setup targets
target("sfse-clean-main-menu")
    -- add dependencies to target
    add_deps("commonlibsf")

    -- bind package dependencies
    add_packages("toml++")

    -- add commonlibsf plugin
    add_rules("commonlibsf.plugin", {
        name = "clean-main-menu",
        author = "qudix",
        description = "Removes main menu elements"
    })

    -- add source files
    add_files("src/*.cpp")
    add_headerfiles("src/*.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")

    -- copy build to MODS or GAME paths
    after_build(function(target)
        local copy = function(env, ext)
            for _, env in pairs(env:split(";")) do
                if os.exists(env) then
                    local plugins = path.join(env, ext, "SFSE/Plugins")
                    os.mkdir(plugins)
                    os.trycp(target:targetfile(), plugins)
                    os.trycp(target:symbolfile(), plugins)
                end
            end
        end
        if os.getenv("XSE_SF_MODS_PATH") then
            copy(os.getenv("XSE_SF_MODS_PATH"), target:name())
        elseif os.getenv("XSE_SF_GAME_PATH") then
            copy(os.getenv("XSE_SF_GAME_PATH"), "Data")
        end
    end)
