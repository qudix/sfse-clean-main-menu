-- set minimum xmake version
set_xmakever("2.8.2")

-- add custom package repository
includes("lib/commonlibsf")

-- set project
set_project("sfse-clean-main-menu")
set_version("0.3.2")
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

    -- add install files
    add_installfiles("res/*.toml", { prefixdir = "SFSE/Plugins" })
