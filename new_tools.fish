# tool_nudges — CLI tools catalog
# Canonical location: ~/code/tool_nudges/
# Symlinked from: ~/.config/fish/functions/new_tools.fish
function new_tools --description "Print the new CLI tools catalog"
    set -l tools_file ~/code/tool_nudges/new_tools.yaml
    if not test -f $tools_file
        echo "Tools database not found at $tools_file"
        return 1
    end

    set -l current_category ""
    set -l current_name ""
    set -l current_replaces ""

    while read -l line
        # Category headers
        if string match -qr '^\s+category: "(.+)"' -- $line
            set -l cat (string replace -r '^\s+category: "(.+)"' '$1' -- $line)
            if test "$cat" != "$current_category"
                set current_category $cat
                echo ""
                set_color --bold bryellow
                echo "  $current_category"
                set_color normal
                echo "  "(string repeat -n (string length "$current_category") "─")
            end
        end

        # Tool name
        if string match -qr '^\s+- name: (.+)' -- $line
            set current_name (string replace -r '^\s+- name: (.+)' '$1' -- $line)
        end

        # Replaces
        if string match -qr '^\s+replaces: (.+)' -- $line
            set -l repl (string replace -r '^\s+replaces: (.+)' '$1' -- $line)
            if test "$repl" != '""' -a -n "$repl"
                set current_replaces $repl
            else
                set current_replaces ""
            end
        end

        # Description
        if string match -qr '^\s+description: "(.+)"' -- $line
            set -l desc (string replace -r '^\s+description: "(.+)"' '$1' -- $line)
            printf "  "
            set_color --bold brgreen
            printf "%-12s" $current_name
            set_color normal
            if test -n "$current_replaces"
                set_color brred
                printf "→ %-6s " $current_replaces
                set_color normal
            else
                printf "         "
            end
            printf "%s\n" $desc
        end

        # Example
        if string match -qr '^\s+example: "(.+)"' -- $line
            set -l ex (string replace -r '^\s+example: "(.+)"' '$1' -- $line)
            set_color brblack
            printf "              %s\n" $ex
            set_color normal
        end
    end < $tools_file

    echo ""
end
