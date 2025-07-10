module JuliaJupyterDevContainer

using TOML

export print_package_info

function get_version()
    # Adjust the path as needed if Project.toml is elsewhere
    toml_path = joinpath(@__DIR__, "..", "Project.toml")
    toml = TOML.parsefile(toml_path)
    return toml["version"]
end

function print_package_info()
    println("Package: JuliaJupyterDevContainer")
    println("Version: ", get_version())
end

end