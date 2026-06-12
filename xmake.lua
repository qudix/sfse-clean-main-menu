includes("lib/commonlibsf")

set_project("sfse-clean-main-menu")
set_version("0.3.2")
set_license("GPL-3.0")
set_languages("c++23")
set_warnings("allextra")

add_rules("mode.releasedbg", "mode.debug")
add_rules("plugin.vsxmake.autoupdate")

set_config("commonlib_toml", true)

target("sfse-clean-main-menu")
    add_rules("commonlibsf.plugin", {
        name = "clean-main-menu",
        author = "qudix",
        description = "Removes main menu elements"
    })

    add_files("src/*.cpp")
    add_headerfiles("src/*.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")

    add_installfiles("res/*.toml", { prefixdir = "SFSE/Plugins" })
