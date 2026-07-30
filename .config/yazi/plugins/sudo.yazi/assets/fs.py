#!/usr/bin/env python3

import os
import sys
import shutil
import argparse

def legit_name(path):
    if not os.path.exists(path):
        return path
    name, ext = os.path.splitext(path)
    i = 1
    while True:
        new_name = f"{name}_{i}{ext}"
        if not os.path.exists(new_name):
            return new_name
        i += 1

def cp(paths, force=False):
    for src in paths:
        dest = os.path.basename(src)
        if not force:
            dest = legit_name(dest)
        if os.path.isdir(src):
            shutil.copytree(src, dest, dirs_exist_ok=True)
        else:
            shutil.copy2(src, dest)
        print(f"Copied {src} to {dest}")

def mv(paths, force=False):
    for src in paths:
        dest = os.path.basename(src)
        if not force:
            dest = legit_name(dest)
        shutil.move(src, dest)
        print(f"Moved {src} to {dest}")

def ln(paths, relative=False):
    for src in paths:
        dest = legit_name(os.path.basename(src))
        if relative:
            os.symlink(os.path.relpath(src), dest)
        else:
            os.symlink(src, dest)
        print(f"Linked {src} to {dest}")

def hardlink(paths):
    for src in paths:
        dest = legit_name(os.path.basename(src))
        os.link(src, dest)
        print(f"Hardlinked {src} to {dest}")

def rm(paths, permanent=False):
    for path in paths:
        if permanent:
            if os.path.isdir(path):
                shutil.rmtree(path)
            else:
                os.remove(path)
            print(f"Permanently removed {path}")
        else:
            # A more robust solution would use a trash library
            print(f"Moved {path} to trash (simulation)")


def main():
    parser = argparse.ArgumentParser(description="Sudo file operations")
    subparsers = parser.add_subparsers(dest="command")

    cp_parser = subparsers.add_parser("cp")
    cp_parser.add_argument("paths", nargs="+")
    cp_parser.add_argument("--force", action="store_true")

    mv_parser = subparsers.add_parser("mv")
    mv_parser.add_argument("paths", nargs="+")
    mv_parser.add_argument("--force", action="store_true")

    ln_parser = subparsers.add_parser("ln")
    ln_parser.add_argument("paths", nargs="+")
    ln_parser.add_argument("--relative", action="store_true")

    hardlink_parser = subparsers.add_parser("hardlink")
    hardlink_parser.add_argument("paths", nargs="+")

    rm_parser = subparsers.add_parser("rm")
    rm_parser.add_argument("paths", nargs="+")
    rm_parser.add_argument("--permanent", action="store_true")

    args = parser.parse_args()

    if args.command == "cp":
        cp(args.paths, args.force)
    elif args.command == "mv":
        mv(args.paths, args.force)
    elif args.command == "ln":
        ln(args.paths, args.relative)
    elif args.command == "hardlink":
        hardlink(args.paths)
    elif args.command == "rm":
        rm(args.paths, args.permanent)

if __name__ == "__main__":
    main()
