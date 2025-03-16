#!/usr/bin/env python3
# title          :get-apt-leaves.sh
# description    :Find leaf packages in APT - packages that no other installed packages depend on.
# author         :Tassilo Neubauer
# date           :20250316
# version        :0.1
# usage          :./get-apt-leaves.sh
# notes          :
# bash_version   :5.1.16(1)-release
# ============================================================================

import subprocess
import sys


def get_installed_packages():
    """Get a set of all installed packages."""
    result = subprocess.run(
        ["dpkg-query", "-f", "${Package}\n", "-W"],
        capture_output=True,
        text=True,
        check=True,
    )
    return set(result.stdout.strip().split("\n"))


def get_manually_installed_packages():
    """Get a list of manually installed packages."""
    result = subprocess.run(
        ["apt-mark", "showmanual"], capture_output=True, text=True, check=True
    )
    return result.stdout.strip().split("\n")


def get_reverse_depends(package):
    """Get packages that depend on the given package."""
    result = subprocess.run(
        ["apt-cache", "rdepends", package], capture_output=True, text=True, check=False
    )

    # Parse the output to extract reverse dependencies
    lines = result.stdout.strip().split("\n")

    # Skip the first line (package name) and the "Reverse Depends:" line
    rdepends = []
    capture = False
    for line in lines:
        if line.strip() == "Reverse Depends:":
            capture = True
            continue
        if capture and line.startswith("  "):
            # Extract the package name, handling "|" for alternatives and removing version constraints
            pkg = line.strip().split("|")[0].split()[0]
            rdepends.append(pkg)

    return set(rdepends)


def main():
    try:
        print("Finding leaf packages...")

        # Get all installed packages
        all_installed = get_installed_packages()

        # Get manually installed packages (can be filtered with command line args)
        manually_installed = get_manually_installed_packages()

        # If command line args provided, filter to just those packages
        if len(sys.argv) > 1:
            filter_packages = sys.argv[1:]
            manually_installed = [p for p in manually_installed if p in filter_packages]

        # Find leaf packages (those with no other installed packages depending on them)
        leaf_packages = []
        total = len(manually_installed)

        print(f"Analyzing {total} manually installed packages...")

        for i, package in enumerate(manually_installed):
            # Show progress
            if i % 10 == 0:
                progress = (i / total) * 100
                print(f"Progress: {progress:.1f}% ({i}/{total})", end="\r")

            # Get reverse dependencies
            rdepends = get_reverse_depends(package)

            # Remove the package itself from its reverse dependencies
            if package in rdepends:
                rdepends.remove(package)

            # Check if any installed package depends on this one
            installed_rdepends = rdepends.intersection(all_installed)

            if not installed_rdepends:
                leaf_packages.append(package)

        print(f"\nFound {len(leaf_packages)} leaf packages:")
        for package in sorted(leaf_packages):
            print(package)

        # Also write to a file
        with open("leaf-packages.txt", "w") as f:
            for package in sorted(leaf_packages):
                f.write(f"{package}\n")

        print("\nResults also written to leaf-packages.txt")

    except subprocess.CalledProcessError as e:
        print(f"Error executing subprocess: {e}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
