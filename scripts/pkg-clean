#!/bin/bash

### Clean pacman cache ####
[[ -n $(pacman -Qdt) ]] && sudo pacman -Rns $(pacman -Qdtq) || echo "No orphaned packages to remove!" 
paccache --remove --keep 1
paccache --remove --uninstalled --keep 0


### Clean yay cache ###
cachedir="/home/${USER}/.cache/yay"

# Clean yay cache of packages that are not installed anymore
uninstalled="$(comm -23 <(basename -a $(find $cachedir -mindepth 1 -maxdepth 1 -type d) | sort) <(pacman -Qqm) | xargs -r printf "$cachedir/%s\n")"
rm -rf ${uninstalled}

# Remove untracked files (e.g. source/build files) except package files and main source files for installed version if non-git package
for pkgdir in "$cachedir"/*/; do
    pkgname=$(basename "$pkgdir")
    if [[ ! "$pkgname" =~ ^.*-git$ ]]; then
        pkgver="$(pacman -Q $pkgname | cut -d ' ' -f2 | cut -d '-' -f1 | cut -d ':' -f2)"
        cd "$pkgdir"
        rm -f $(git ls-files --others | grep -v -e '^.*\.pkg\.tar.*$' -e '^.*/$' -e "^.*$pkgver.*$" | xargs -r printf "$pkgdir/%s\n")
    fi
    rm -rf "$pkgdir"/src/
done

# Clean yay cache of older versions of installed packages
pkgcache="$(find $cachedir -mindepth 1 -maxdepth 1 -type d | xargs -r printf "-c %s\n")"
paccache --remove --keep 1 $pkgcache
