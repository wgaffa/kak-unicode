define-command -params 0 -override -docstring "
Get info of a certain unicode character
" unicode-info %{
    evaluate-commands %sh{
        out=
        hex=

        echo "$kak_selection" | awk '{if (length($0) > 1) exit 1}';
        if [ $? -eq 0 ]; then
            out=`unicode-cli info "${kak_selection}"`
            hex=`printf "%x" "${kak_cursor_char_value}"`
        else
            out=`unicode-cli inspect "${kak_selection}"`
        fi

        printf "info '$out\n${hex:+hex: $hex}'"
    }
}

define-command -params 0..1 -override -docstring "
Search for a unicode character
" unicode-search %{
    evaluate-commands -draft -save-regs '"' %sh{
        val=$kak_selection
        if [ -n "$1" ]; then
            val=$1
        fi
        out=`unicode-cli search "$val" | awk '{for (i=1;i<=length($0);i++) print substr($0, i, 1)}' | fzf-tmux --preview='unicode-cli info {}'`
        if [ $? -eq 0 ]; then
            printf "set-register dquote '$out'\n"
            printf "execute-keys R"
        fi
    }
}

