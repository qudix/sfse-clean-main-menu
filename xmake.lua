-- set minimum xmake version
set_xmakever("2.8.2")

-- add custom package repository
add_repositories("re https://github.com/Starfield-Reverse-Engineering/commonlibsf-xrepo")

-- set project
set_project("commonlibsf-template")
set_version("0.0.0")
set_license("GPL-3.0")

-- set defaults
set_languages("c++23")
set_optimize("faster")
set_warnings("allextra", "error")
set_defaultmode("releasedbg")

-- add rules
add_rules("mode.releasedbg", "mode.debug")
add_rules("plugin.vsxmake.autoupdate")

-- require package dependencies
add_requires("commonlibsf")

-- setup targets
target("commonlibsf-template")
    -- bind package dependencies
    add_packages("commonlibsf")

    -- add commonlibsf plugin
    add_rules("@commonlibsf/plugin", {
        name = "commonlibsf-template",
        author = "Author Name",
        description = "Plugin Description",
        email = "user@site.com"
    })

    -- add source files
    add_files("src/*.cpp")
    add_headerfiles("src/*.h")
    add_includedirs("src")
    set_pcxxheader("src/pch.h")
