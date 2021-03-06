###
### BASH INITIALIZATION FUNCTIONS
###

# Helper functions for defining a bash environment.
# All functions and variables can be unset by calling `CLEANUP`.
# Bash 3.1+ compatible.

### Temporary collections
# __SECLIST__ contains files that should be checked for loose privileges.
# __GC_FUNC__ contains functions to be unset after shell init.
# __GC_VARS__ contains variables to be unset after shell init.
__SECLIST__=()
__GC_FUNC__=(SECLIST GC_FUNC GC_VARS)
__GC_VARS__=(__SECLIST__ __GC_FUNC__ __GC_VARS__)

# Corresponding accumulation functions for convenience
# Param: $@ List of file/function/variable names
SECLIST() { __SECLIST__+=("$@"); }
GC_FUNC() { __GC_FUNC__+=("$@"); }
GC_VARS() { __GC_VARS__+=("$@"); }

# Sweep garbage collection lists
CLEANUP() {
    unset -f "${__GC_FUNC__[@]}"
    unset "${__GC_VARS__[@]}"
}; GC_FUNC CLEANUP

### Abort the login process.
# Param: $* Error message
ABORT() {
    # Explain
    (($#)) && echo -e "$*\n" >&2

    # Stack trace
    local i
    for ((i = 0; i < ${#BASH_SOURCE[@]} - 1; ++i)); do
        echo "-> ${BASH_SOURCE[i+1]}:${BASH_LINENO[i]}:${FUNCNAME[i]}" >&2
    done

    # Clean up, send interrupt signal, and suspend execution
    CLEANUP
    echo -e "\n\e[1;3;31mAborting shell initialization.\e[0m\n" >&2
    while true; do kill -INT $$; sleep 60; done
}; GC_FUNC ABORT

### Source file and abort on failure
# Param: $1 Filename
REQUIRE() {
    [[ -e "$1" ]] || ABORT "\"$1\" does not exist!"
    [[ -r "$1" ]] || ABORT "No permissions to read \"$1\""
    source "$1"   || ABORT "\`source $1\` returned false!"
}; GC_FUNC REQUIRE

### Simple wrapper around `type`
# Param: $@ List of commands/aliases/functions
HAVE() { type "$@" &>/dev/null; }; GC_FUNC HAVE

# Simple platform checks
__OS_X__()  { [[ "$MACHTYPE" == *darwin* ]]; }; GC_FUNC __OS_X__
__LINUX__() { [[ "$MACHTYPE" == *linux*  ]]; }; GC_FUNC __LINUX__

### Security check
#
# Check to see if current user or root owns and has sole write privileges
# on all files in SECLIST.
#
# Clears SECLIST on success and aborts on failure.
CHECK_SECLIST() {
    # Don't spin up a ruby interpreter if we don't have to
    (( ${#__SECLIST__[@]} )) || return

    if ruby -e '
        ARGV.each do |file|
            next if file.empty?
            path = File.expand_path file
            next unless File.exists? path
            stat = File.stat path

            if stat.uid != Process.euid and not stat.uid.zero?
                require "etc"
                fmt = "%s is trusted, but is owned by %s!"
                abort fmt % [path.inspect, Etc.getpwuid(stat.uid).name.inspect]
            elsif not ((mode = stat.mode) & 0002).zero?
                abort "%s is trusted, but is world writable!" % path.inspect
            elsif not (mode & 0020).zero?
                abort "%s is trusted, but is group writable!" % path.inspect
            end
        end
    ' "${__SECLIST__[@]}"; then
        __SECLIST__=()
    else
        ABORT "\nYour shell is at risk of being compromised."
    fi
}; GC_FUNC CHECK_SECLIST

### Processes array variable PATH_ARY and exports PATH.
#
# PATH_ARY may consist of directories or colon-delimited PATH strings.
# Duplicate, non-searchable, and non-extant directories are pruned, as well
# directories that are not owned by the current user or root.
#
# Valid paths are added to __SECLIST__ and reviewed.
EXPORT_PATH() {
    export PATH="$(ruby -e '
        print ARGV.flat_map { |arg|
            arg.split(":").map { |p| File.symlink?(p) ? File.expand_path(File.readlink(p), File.dirname(p)) : p }
        }.uniq.select { |path|
            if File.directory? path and File.executable? path
                stat = File.stat path
                stat.uid == Process.euid or stat.uid.zero?
            end
        }.join(":")
    ' "${PATH_ARY[@]}")"

    # We want to sweep this variable
    GC_VARS PATH_ARY

    # We also want to check permissions before proceeding
    local IFS=$':'
    __SECLIST__+=($PATH)
    unset IFS
    CHECK_SECLIST
}; GC_FUNC EXPORT_PATH

### Lazy completion transfer function:
#
# The Bash-completion project v2.0 introduces dynamic loading of completions,
# which greatly shortens shell initialization time. A result of this is that
# completions can no longer be simply transferred using:
#
#   eval "$({ complete -p $source || echo :; } 2>/dev/null)" $target
#
# A workaround is to create a completion function that dynamically loads the
# source completion, then replaces itself with the new completion, finally
# invoking the new completion function to save the user from having to resend
# the completion command.
#
# This is also much faster at shell initialization.
#
# Param: $1 Source command
# Param: $2 Target command
TCOMP() {
    local src="$1" alias="$2"

    eval "__${FUNCNAME}_${alias}__() {
        # Unset self and remove extant compspec
        unset \"__${FUNCNAME}_${alias}__\" 2>/dev/null
        complete -r \"$alias\"

        # Load completion through bash-completion 2.0 dynamic loading function
        if complete -p \"$src\" &>/dev/null || _load_comp \"$src\"; then
            while true; do
                local cspec=\"\$(complete -p \"$src\" 2>/dev/null)\"
                local cfunc=\"\$(sed -ne \"s/.*-F \\(.*\\) .*/\1/p\" <<< \"\$cspec\")\"
                if [[ \"\$cfunc\" == __${FUNCNAME}_*__ ]]; then
                    # If this is another lazy completion, call now to load
                    \$cfunc
                else
                    break
                fi
            done
            # Dynamic load may have loaded empty compspec
            [[ \$cspec ]] || return 1
            # If a compspec was successfully loaded, transfer to target and invoke
            eval \"\$cspec\" \"$alias\"
            if [[ \$cfunc ]]; then
                _xfunc \"$src\" \"\$cfunc\"
            elif [[ \$cspec == complete\ * ]]; then
                COMPREPLY=(\$(compgen \$(sed -ne \"s/complete \(.*\) $src.*/\1/p\" <<< \"\$cspec\") \"\${COMP_WORDS[COMP_CWORD]}\"))
            fi
        fi
    }; complete -F \"__${FUNCNAME}_${alias}__\" \"$alias\""
}; GC_FUNC TCOMP

### Smarter aliasing function:
#
#   * Lazily transfers completions to the alias using TCOMP():
#
#       complete -p exec                        => complete -F _command exec
#       ALIAS x exec && complete -p x           => complete -F __TCOMP_x__ x
#       x <TAB>; complete -p x                  => complete -F _command x
#
#   * Skips alias and returns false if command does not exist:
#
#       ALIAS pony='/bin/magic-pony'            => (no alias)
#       ALIAS unicorn='magic-pony --with-horn'  => (no alias)
#       echo $!                                 => `1`
#
#   * Early termination:
#
#       ALIAS mp='magic-pony' ls='ls -Ahl'      => `ls` remains unaliased
#
# NOTE: In order to attain acceptable performance, this function is not
#       parameter compatible with the `alias` builtin!
#
# Param: $@ name=value ...
ALIAS() {
    local arg
    for arg in "$@"; do
        # Split argument into name and (array)value; eval preserves user's
        # quoting and escaping (for the most part)
        local name="${arg%%=*}"
        eval "local val=(${arg#*=})"
        local cmd="${val[0]}" opts="${val[@]:1}"

        if HAVE "$cmd"; then
            # Escape spaces in cmd; doesn't escape other shell metacharacters!
            builtin alias "$name=${cmd// /\\ } ${opts[@]}"
            # Transfer completions to the new alias
            if [[ "$name" != "$cmd" ]]; then
                TCOMP "$cmd" "$name"
            fi
        else
            return 1
        fi
    done
}; GC_FUNC ALIAS

### `cd` wrapper creation:
#
# CD_FUNC foo /usr/local/foo ...
#
#   * Creates shell variable $foo, suitable for use as an argument:
#
#       $ cp bar $foo/subdir
#
#   * Creates shell function foo():
#
#       $ foo               # Changes working directory to `/usr/local/foo`
#       $ foo bar/baz       # Changes working directory to `/usr/local/foo/bar/baz`
#
#   * Creates completion function __foo__() which completes foo():
#
#       $ foo <Tab>         # Returns all directories in `/usr/local/foo`
#       $ foo bar/<Tab>     # Returns all directories in `/usr/local/foo/bar`
#
#   * If `/usr/local/foo` does not exist or is not a directory, and multiple
#     arguments are given, each argument is tested until an extant directory
#     is found. Otherwise does nothing and returns false.
#
# CD_FUNC -n ... ../..
#
#   * No check for extant directory with `-n`
#
# CD_FUNC -f cdgems 'ruby -rubygems -e "puts Gem.dir"'
#
#   * Shell variable $cdgems only created after first invocation
#
#   * Lazy evaluation; avoids costly invocations at shell init
#
# Option: -n     Do not check if directory exists
# Option: -f     Parameter $2 is a shell function
# Param:  $1     Name of created function/variable
# Param:  ${@:2} List of directories
CD_FUNC() {
    local isfunc=0 checkdir=1
    local OPTIND OPTARG opt
    while getopts :fn opt; do
        case $opt in
        f) isfunc=1;;
        n) checkdir=0;;
        esac
    done
    shift $((OPTIND-1))

    local name func dir

    if ((isfunc)); then
        name="$1" func="$2"

        eval "$name() {
            if [[ \"\$$name\" ]]; then
                cd \"\$$name/\$1\"
            else
                cd \"\$($func)/\$1\"
                # Set shell variable on first call
                [[ \"\$$name\" ]] || $name=\"\$PWD\" 2>/dev/null
            fi
        }"
    else
        local name="$1"

        # Loop through arguments till we find a match
        if ((checkdir)); then
            local arg
            for arg in "${@:2}"; do
                if [[ -d "$arg" ]]; then
                    dir="$arg"
                    break
                fi
            done
            [[ "$dir" ]] || return 1
        else
            dir="$2"
        fi

        # Set shell variable and function
        eval "$name=\"$dir\"" 2>/dev/null
        eval "$name() { cd \"$dir/\$1\"; }"
    fi

    # Set completion function
    eval "__${name}__() {
        local cur=\"\${COMP_WORDS[COMP_CWORD]}\"
        local words=\"\$(
            # Change to base directory
            $name

            local base line
            # If the current word doesn't have a slash, this is the first comp
            if [[ \"\$cur\" != */* ]]; then
                command ls -A1 | while read line; do
                    [[ -d \"\$line\" ]] && echo \"\${line%/}/\"
                done
            else
                # Chomp the trailing slash and dequote
                base=\"\$(eval printf %s \"\${cur%/}\")\"

                # If this directory doesn't exist, try its parent
                [[ -d \"\$base\" ]] || base=\"\${base%/*}\"

                # Return directories
                command ls -A1 \"\$base\" | while read line; do
                    [[ -d \"\$base/\$line\" ]] && echo \"\$base/\${line%/}/\"
                done
            fi
        )\"

        local IFS=\$'\\n'
        COMPREPLY=(\$(grep -i \"^\$cur.*\" <<< \"\$words\"))
    }"

    # Complete the shell function
    complete -o nospace -o filenames -F "__${name}__" "$name"
}; GC_FUNC CD_FUNC

### Init script wrapper creation:
#
# RC_FUNC rcd /etc/rc.d ...
#
#   * Creates shell function rcd(), which executes scripts in `/etc/rc.d`:
#
#       $ rcd sshd restart
#
#   * Creates completion function __rcd__() which completes rcd():
#
#       $ rcd <Tab>                     # Returns all scripts in /etc/rc.d
#       $ rcd sshd <Tab>                # Returns subcommands for /etc/rc.d/sshd
#
#   * If `/etc/rc.d` does not exist or is not a directory, and multiple
#     arguments are given, each argument is tested until an extant directory
#     is found. Otherwise does nothing and returns false.
#
# Param: $1     Name of created function
# Param: ${@:2} List of rc/init directories
RC_FUNC() {
    local name="$1" arg dir
    for arg in "${@:2}"; do
        if [[ -d "$arg" ]]; then
            dir="$arg"
            break
        fi
    done
    [[ "$dir" ]] || return 1

    # Shell function
    eval "$name() { [[ -x \"$dir/\$1\" ]] && \"$dir/\$1\" \"\${@:2}\"; }"

    # Completion function
    eval "__${name}__() {
        local cur=\"\${COMP_WORDS[COMP_CWORD]}\"
        local prev=\"\${COMP_WORDS[COMP_CWORD-1]}\"
        local words

        if [[ \"\$prev\" == \"\${COMP_WORDS[0]}\" ]]; then
            words=\"\$(command ls -1 \"$dir/\")\"
        else
            words='start stop restart'
        fi

        COMPREPLY=(\$(compgen -W \"\$words\" -- \$cur))
    }"

    # Complete the shell function
    complete -F __${name}__ $name
}; GC_FUNC RC_FUNC

### HAPPY HACKING

GREETINGS() {
    local date="$(date +%H:%M:%S\ %Z)" color
    local hour="${date%%:*}"; hour="${hour#0}"

    if   ((hour < 6 || hour > 21)); then color='34' # night
    elif ((hour < 10));             then color='36' # morning
    elif ((hour < 18));             then color='33' # day
    else                                 color='35' # evening
    fi

    echo -e "\n\e[1;32mGNU Bash \e[0;3m($BASH_VERSION)\e[0m ⚡ \e[1;${color}m$date\e[0m\n"
}; GC_FUNC GREETINGS
