# Nushell Config File
# version = "0.101.0"

$env.config.show_banner = false
$env.EDITOR = "/home/lux/.nix-profile/bin/lvim"
source ~/.local/share/atuin/init.nu
source ~/.config/nushell/zoxide.nu
source ~/.config/nushell/aliases.nu
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
source ~/.cache/carapace/init.nu

# use ./custom-completions/adb/adb-completions.nu
# use ./custom-completions/ani-cli/ani-cli-completions.nu
# use ./custom-completions/bitwarden-cli/bitwarden-cli-completions.nu
# use ./custom-completions/cargo/cargo-completions.nu
# use ./custom-completions/curl/curl-completions.nu
# use ./custom-completions/docker/docker-completions.nu
# use ./custom-completions/eza/eza-completions.nu
# use ./custom-completions/fastboot/fastboot-completions.nu
use ./custom-completions/git/git-completions.nu
# use ./custom-completions/nix/nix-completions.nu
# use ./custom-completions/npm/npm-completions.nu
# use ./custom-completions/ssh/ssh-completions.nu
# use ./custom-completions/tar/tar-completions.nu
# use ./custom-completions/virsh/virsh-completions.nu
# use ./custom-completions/winget/winget-completions.nu

#completers
# let zoxide_completer = {|spans| $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD} }
let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}
let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | from tsv --flexible --noheaders --no-infer
    | rename value description
}
let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }

    match $spans.0 {
        # carapace completions are incorrect for nu
        nu => $fish_completer
        # fish completes commits and branch names in a nicer way
        git => $fish_completer
        # carapace doesn't have completions for asdf
        asdf => $fish_completer
        # use zoxide completions for zoxide commands
        # __zoxide_z | __zoxide_zi => $zoxide_completer
        _ => $carapace_completer
    } | do $in $spans
}
$env.config.completions.external = {
    enable: true
    max_results: 100
    completer: $external_completer
}

# $env.config.color_config = {
#     separator: white
#     leading_trailing_space_bg: { attr: n }
#     header: green_bold
#     empty: blue
#     bool: light_cyan
#     int: white
#     filesize: cyan
#     duration: white
#     date: purple
#     range: white
#     float: white
#     string: white
#     nothing: white
#     binary: white
#     cell-path: white
#     row_index: green_bold
#     record: white
#     list: white
#     closure: green_bold
#     glob:cyan_bold
#     block: white
#     hints: dark_gray
#     search_result: { bg: red fg: white }
#     shape_binary: purple_bold
#     shape_block: blue_bold
#     shape_bool: light_cyan
#     shape_closure: green_bold
#     shape_custom: green
#     shape_datetime: cyan_bold
#     shape_directory: cyan
#     shape_external: cyan
#     shape_externalarg: green_bold
#     shape_external_resolved: light_yellow_bold
#     shape_filepath: cyan
#     shape_flag: blue_bold
#     shape_float: purple_bold
#     shape_glob_interpolation: cyan_bold
#     shape_globpattern: cyan_bold
#     shape_int: purple_bold
#     shape_internalcall: cyan_bold
#     shape_keyword: cyan_bold
#     shape_list: cyan_bold
#     shape_literal: blue
#     shape_match_pattern: green
#     shape_matching_brackets: { attr: u }
#     shape_nothing: light_cyan
#     shape_operator: yellow
#     shape_pipe: purple_bold
#     shape_range: yellow_bold
#     shape_record: cyan_bold
#     shape_redirection: purple_bold
#     shape_signature: green_bold
#     shape_string: green
#     shape_string_interpolation: cyan_bold
#     shape_table: blue_bold
#     shape_variable: purple
#     shape_vardecl: purple
#     shape_raw_string: light_purple
#     shape_garbage: {
#         fg: white
#         bg: red
#         attr: b
#     }
# }
