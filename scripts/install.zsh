mkdir -p ~/.config/quickshell/caelestia
cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/ -DINSTALL_QSCONFDIR="$HOME/.config/quickshell/caelestia"
if [ $? -ne 0 ]; then
    echo "CMake configuration failed."
    exit 1
fi
cmake --build build
if [ $? -ne 0 ]; then
    echo "Build failed."
    exit 1
fi
sudo cmake --install build
if [ $? -ne 0 ]; then
    echo "Installation failed."
    exit 1
fi
sudo chown -R $USER ~/.config/quickshell/caelestia
if [ $? -ne 0 ]; then
    echo "Failed to change ownership of configuration directory."
    exit 1
fi