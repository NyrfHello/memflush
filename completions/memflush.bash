# bash completion for memflush                               -*- shell-script -*-

_memflush() {
    local cur prev words cword
    _init_completion || return

    local options="-n --no-notify -s --silent -q --quiet -v --version -h --help"

    case "${cur}" in
        -*)
            COMPREPLY=( $(compgen -W "${options}" -- "${cur}") )
            return 0
            ;;
        *)
            ;;
    esac
}

complete -F _memflush memflush
