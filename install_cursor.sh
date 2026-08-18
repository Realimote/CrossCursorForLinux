#!/bin/bash

cursor_path=$(cd "$(dirname "$0")" ; pwd)

install_cursor() {
    mkdir -p "${HOME}/.icons" || return 1
    cp -r "${cursor_path}" "${HOME}/.icons" || return 1
    return 0
}

get_cursor_set_command() {
    local cursor_name=$1
    cat<<EOF
Cinnamon:
    gsettings set org.cinnamon.desktop.interface cursor-theme "${cursor_name}"

Gnome:
    gsettings set org.gnome.desktop.interface cursor-theme "${cursor_name}"

Mate:
    gsettings set org.mate.peripherals-mouse cursor-theme "${cursor_name}"

KDE:
    if command -v plasma-apply-cursortheme >/dev/null 2>&1; then
        plasma-apply-cursortheme "${cursor_name}"
    fi
    if command -v kwriteconfig6 >/dev/null 2>&1; then
        kwriteconfig6 --file kcminputrc --group Mouse --key cursorTheme "${cursor_name}"
    elif command -v kwriteconfig5 >/dev/null 2>&1; then
        kwriteconfig5 --file kcminputrc --group Mouse --key cursorTheme "${cursor_name}"
    fi
    if command -v dbus-send >/dev/null 2>&1; then
        dbus-send --session --type=signal /KGlobalSettings org.kde.KGlobalSettings.notifyChange int32:5 int32:0
    fi

LXQt:
    mkdir -p "${HOME}/.config/lxqt"
    session_conf="${HOME}/.config/lxqt/session.conf"
    if [ ! -f "${session_conf}" ]; then
        printf '[General]\ncursor_theme=%s\n' "${cursor_name}" > "${session_conf}"
    elif grep -q '^cursor_theme=' "${session_conf}"; then
        sed -i "s/^cursor_theme=.*/cursor_theme=${cursor_name}/" "${session_conf}"
    elif grep -q '^\[General\]' "${session_conf}"; then
        sed -i "/^\[General\]/a cursor_theme=${cursor_name}" "${session_conf}"
    else
        printf '\n[General]\ncursor_theme=%s\n' "${cursor_name}" >> "${session_conf}"
    fi
    touch "${HOME}/.Xresources"
    if grep -q '^Xcursor.theme:' "${HOME}/.Xresources"; then
        sed -i "s/^Xcursor.theme:.*/Xcursor.theme: ${cursor_name}/" "${HOME}/.Xresources"
    else
        printf 'Xcursor.theme: %s\n' "${cursor_name}" >> "${HOME}/.Xresources"
    fi
    if command -v xrdb >/dev/null 2>&1; then
        xrdb -merge "${HOME}/.Xresources"
    fi
    if command -v dbus-update-activation-environment >/dev/null 2>&1; then
        dbus-update-activation-environment --systemd "XCURSOR_THEME=${cursor_name}"
    fi
    if command -v xsetroot >/dev/null 2>&1; then
        xsetroot -cursor_name left_ptr
    fi

Xfce:
    xfconf-query --channel xsettings --property /Gtk/CursorThemeName --create --type string --set "${cursor_name}"
EOF
}

echo "将鼠标指针安装至 '${HOME}/.icons/十字光标'"

if install_cursor; then
    echo "'十字光标' 鼠标指针安装完成, 可使用运行下面的命令启用该鼠标指针"
    get_cursor_set_command "十字光标"
else
    echo "鼠标指针安装到 '${HOME}/.icons/十字光标' 失败, 请检查是否有 root 权限或者检查目录是否存在"
    exit 1
fi