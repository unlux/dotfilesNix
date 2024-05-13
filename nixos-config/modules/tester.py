# Python
import re

# Read the file
with open('systemPkgs.nix', 'r') as f:
    content = f.read()

# Find all package names using regex
packages = re.findall(r'\b\w+\b', content)

# Remove duplicates while preserving order
unique_packages = list(dict.fromkeys(packages))

# Write the unique packages back to the file
with open('systemPkgs.nix', 'w') as f:
    for package in unique_packages:
        f.write(package + '\n')
