# Check qmllint, qmlformat, and ./qml-lint-conventions.py for all QML files in the project.

function error_exit {
    printf "\033[31m$1\033[0m\n" 1>&2
    exit 1
}

function echo_info {
    printf "\033[34m$1\033[0m\n"
}

function echo_success {
    printf "\033[32m$1\033[0m\n"
}

echo_info "==============================================================="
echo_info "Checking QML files with qmllint and qmlformat"
echo_info "==============================================================="
echo ""
for file in **/*.qml; do
    if [[ "$file" == *"build/"* ]]; then
        continue
    fi
    echo "Checking $file"
    /usr/lib/qt6/bin/qmllint "$file" || error_exit "qmllint failed for $file"
    /usr/lib/qt6/bin/qmlformat "$file" | diff -u "$file" - || error_exit "qmlformat failed for $file"
done

echo ""
echo_success "All QML files passed qmllint and qmlformat checks."
echo ""

echo_info "==============================================================="
echo_info "Checking QML conventions with ./qml-lint-conventions.py"
echo_info "==============================================================="
echo ""
script_path="$(dirname "$0")/qml-lint-conventions.py"
if [ ! -f "$script_path" ]; then
    script_path="$(dirname "$0")/scripts/qml-lint-conventions.py"
    if [ ! -f "$script_path" ]; then
        error_exit "Could not find qml-lint-conventions.py script."
    fi
fi
python3 "$script_path" || exit_exit "qml-lint-conventions.py failed"

echo ""
echo_success "All QML files passed qml-lint-conventions.py checks."