#!/usr/bin/env zsh

setopt errexit nounset pipefail

readonly SCRIPT_DIR="${0:A:h}"
readonly CSV_FILE="${1:-$SCRIPT_DIR/test-input.csv}"
readonly CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/caelestia/shell.json"
readonly ACCEPTED_VALUE="yes"

if (( ! $+commands[jq] )); then
    print -u2 "error: jq is required"
    exit 1
fi

if [[ ! -f "$CSV_FILE" ]]; then
    print -u2 "error: CSV file not found: $CSV_FILE"
    exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
    print -u2 "error: config file not found: $CONFIG_FILE"
    exit 1
fi

if ! jq empty "$CONFIG_FILE" >/dev/null 2>&1; then
    print -u2 "error: config file is not valid JSON: $CONFIG_FILE"
    exit 1
fi

header=""
IFS= read -r header < "$CSV_FILE" || {
    print -u2 "error: CSV file is empty"
    exit 1
}

typeset -a fields
fields=("${(@s/;/)header}")

if (( ${#fields} < 2 )); then
    print -u2 "error: the last CSV column must be OK?"
    exit 1
fi
if [[ "${fields[${#fields}]}" != 'OK?' ]]; then
    print -u2 "error: the last CSV column must be OK?"
    exit 1
fi

integer field_count=$(( ${#fields} - 1 ))
line=""
integer row_number=0
typeset -a values

while IFS= read -r line; do
    row_number=$(( row_number + 1 ))
    [[ -z "$line" ]] && continue

    values=("${(@s/;/)line}")
    if (( ${#values} != ${#fields} )); then
        print -u2 "error: line $row_number has ${#values} columns; expected ${#fields}"
        exit 1
    fi

    [[ -n "${values[${#values}]}" ]] && continue

    typeset temporary_config
    temporary_config="$(mktemp "${TMPDIR:-/tmp}/caelestia-shell.XXXXXX")"
    trap 'rm -f "$temporary_config"' EXIT INT TERM

    typeset jq_filter='.'
    integer index
    key=""
    value=""
    for (( index = 1; index <= field_count; index++ )); do
        key="${fields[index]}"
        value="${values[index]}"
        if [[ -z "$key" ]]; then
            print -u2 "error: empty field name in CSV header"
            exit 1
        fi
        jq_filter+=" | setpath((\$key${index} | split(\".\")); \$value${index})"
    done

    typeset -a jq_args
    jq_args=()
    for (( index = 1; index <= field_count; index++ )); do
        jq_args+=(--arg "key${index}" "${fields[index]}")
        jq_args+=(--arg "value${index}" "${values[index]}")
    done

    jq "$jq_filter" "${jq_args[@]}" "$CONFIG_FILE" > "$temporary_config"
    mv "$temporary_config" "$CONFIG_FILE"
    trap - EXIT INT TERM

    print "Test $(( row_number - 1 )):"
    for (( index = 1; index <= field_count; index++ )); do
        print "  ${fields[index]}=${values[index]}"
    done

    answer=""
    integer accepted=0
    while true; do
        vared -p "Is everything OK? [y/n] " answer
        case "${answer:l}" in
            y|yes)
                accepted=1
                break
                ;;
            n|no)
                answer=""
                break
                ;;
            *)
                print "Please answer y or n."
                ;;
        esac
    done

    if (( accepted )); then
        typeset temporary_csv
        temporary_csv="$(mktemp "${TMPDIR:-/tmp}/caelestia-input.XXXXXX")"
        trap 'rm -f "$temporary_csv"' EXIT INT TERM
        awk -v target="$row_number" -v accepted="$ACCEPTED_VALUE" '
            NR == target {
                sub(/;$/, ";" accepted)
            }
            { print }
        ' "$CSV_FILE" > "$temporary_csv"
        mv "$temporary_csv" "$CSV_FILE"
        trap - EXIT INT TERM
    fi
done < "$CSV_FILE"