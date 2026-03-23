# tool_nudges — startup tips + old-command nudges
# Path resolved dynamically via symlink
# Symlinked from: ~/.config/fish/conf.d/new_tools_reminder.fish

if status is-interactive

    # --- Startup tip ---
    # Pick a random tool tip from the YAML db
    set -l tools_file (path dirname (path resolve (status filename)))/new_tools.yaml
    if test -f $tools_file
        # Extract tool names using string replace in filter mode (-f drops non-matching lines)
        set -l tool_names (string replace -rf '^\s+- name: (.+)' '$1' < $tools_file)
        if test (count $tool_names) -gt 0
            set -l idx (random 1 (count $tool_names))
            set -l tool $tool_names[$idx]

            # Extract this tool's description and example
            set -l desc ""
            set -l example ""
            set -l found 0
            while read -l line
                if string match -q "  - name: $tool" -- $line
                    set found 1
                else if test $found -eq 1
                    if string match -q "  - name:*" -- $line
                        break
                    end
                    if string match -qr '^\s+description: "(.+)"' -- $line
                        set desc (string replace -r '^\s+description: "(.+)"' '$1' -- $line)
                    end
                    if string match -qr '^\s+example: "(.+)"' -- $line
                        set example (string replace -r '^\s+example: "(.+)"' '$1' -- $line)
                    end
                end
            end < $tools_file

            # Display the tip
            set_color bryellow
            printf "💡 "
            set_color normal
            set_color --bold
            printf "%s" $tool
            set_color normal
            printf " — %s\n" $desc
            if test -n "$example"
                set_color brblack
                printf "   %s\n" $example
                set_color normal
            end
        end
    end

    # --- Old-command nudges ---
    # Each wrapper runs the old command, then prints a one-time suggestion to stderr.
    # Uses `command` to call the real binary (avoids infinite recursion).
    # Nudges only fire once per session, tracked via __new_tools_nudged.
    # Output goes to stderr (>&2) and only when stdout is a TTY (not piped).

    set -g __new_tools_nudged

    function __new_tools_nudge
        set -l tool_name $argv[1]
        set -l message $argv[2]
        # Only nudge once per session per tool, and only in TTY
        if isatty stdout; and not contains $tool_name $__new_tools_nudged
            set -ga __new_tools_nudged $tool_name
            set_color brblack >&2
            echo "💡 Try: $message" >&2
            set_color normal >&2
        end
    end

    function find --wraps=find --description "find wrapper with fd nudge"
        command find $argv
        __new_tools_nudge fd "fd — e.g. fd '\\.rb\$' instead of find . -name '*.rb'"
    end

    function ls --wraps=ls --description "ls wrapper with eza nudge"
        command ls $argv
        __new_tools_nudge eza "eza — e.g. eza --tree --git"
    end

    function cat --wraps=cat --description "cat wrapper with bat nudge"
        command cat $argv
        __new_tools_nudge bat "bat — syntax highlighting & line numbers"
    end

    function grep --wraps=grep --description "grep wrapper with rg nudge"
        command grep $argv
        __new_tools_nudge rg "rg — e.g. rg 'pattern' (faster, saner defaults)"
    end

    function sed --wraps=sed --description "sed wrapper with sd nudge"
        command sed $argv
        __new_tools_nudge sd "sd — e.g. sd 'foo' 'bar' file.txt"
    end

    function top --wraps=top --description "top wrapper with btop nudge"
        command top $argv
        __new_tools_nudge btop "btop — beautiful system monitor"
    end

    function du --wraps=du --description "du wrapper with dust nudge"
        command du $argv
        __new_tools_nudge dust "dust — intuitive disk usage viewer"
    end

    function curl --wraps=curl --description "curl wrapper with httpie nudge"
        command curl $argv
        __new_tools_nudge http "http (httpie) — e.g. http GET api.example.com"
    end

end
