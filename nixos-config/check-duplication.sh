#!/usr/bin/env bash
# Script to investigate package duplication in Nix store

PACKAGE=${1:-glibc}
VERSION=${2:-}

echo "=== Investigating: $PACKAGE ==="
echo ""

# Find all versions/copies
if [ -n "$VERSION" ]; then
  PATTERN="*-${PACKAGE}-${VERSION}"
else
  PATTERN="*-${PACKAGE}-*"
fi

echo "1. Finding all store paths..."
PATHS=$(ls -d /nix/store/$PATTERN 2>/dev/null | head -10)
COUNT=$(echo "$PATHS" | wc -l)

if [ -z "$PATHS" ]; then
  echo "No packages found matching: $PATTERN"
  exit 1
fi

echo "Found $COUNT copies:"
echo "$PATHS"
echo ""

# Show first 3 paths for comparison
FIRST=$(echo "$PATHS" | sed -n 1p)
SECOND=$(echo "$PATHS" | sed -n 2p)
THIRD=$(echo "$PATHS" | sed -n 3p)

if [ -n "$FIRST" ] && [ -n "$SECOND" ]; then
  echo "2. Comparing first two copies..."
  echo "   Path 1: $(basename $FIRST)"
  echo "   Path 2: $(basename $SECOND)"
  echo ""

  echo "   Dependencies of path 1:"
  nix-store --query --references "$FIRST" 2>/dev/null | sed 's|/nix/store/||' | head -5
  echo ""

  echo "   Dependencies of path 2:"
  nix-store --query --references "$SECOND" 2>/dev/null | sed 's|/nix/store/||' | head -5
  echo ""

  echo "3. What pulls in each copy?"
  echo ""
  echo "   What depends on path 1:"
  nix-store --query --referrers "$FIRST" 2>/dev/null | sed 's|/nix/store/||' | head -3
  echo ""

  echo "   What depends on path 2:"
  nix-store --query --referrers "$SECOND" 2>/dev/null | sed 's|/nix/store/||' | head -3
  echo ""
fi

echo "4. Quick analysis:"
echo "   - If dependencies differ → different build configurations"
echo "   - If referrers are from different contexts (system vs home) → expected"
echo "   - If referrers include 'unstable' and 'stable' → pkgs vs pkgs-stable"
echo ""
echo "To dig deeper, use:"
echo "   nix-diff $FIRST $SECOND"
echo "   nix why-depends /run/current-system $FIRST"
