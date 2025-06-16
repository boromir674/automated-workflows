#!/usr/bin/env sh
# filepath: scripts/changelog_from_commits.sh

# Usage:
#   PREV_REV=v1.2.3 ./changelog_from_commits.sh [md|rst]
#   ./changelog_from_commits.sh --prev v1.2.3 [md|rst]
#   ./changelog_from_commits.sh --from v1.2.3 [md|rst]

# Default values from environment
PREV_REV="${PREV_REV:-}"
FORMAT="md"
HEADER_LEVEL=3

# Parse command line args
while [ $# -gt 0 ]; do
  case "$1" in
    --prev|--from)
      PREV_REV="$2"
      shift 2
      ;;
    --level|-l)
      HEADER_LEVEL="$2"
      shift 2
      ;;
    md|rst)
      FORMAT="$1"
      shift
      ;;
    *)
      echo "Unknown argument: $1"
      exit 1
      ;;
  esac
done

if [ -z "$PREV_REV" ]; then
  echo "Set previous revision with --prev <rev> or PREV_REV env var"
  exit 1
fi

REV_RANGE="$PREV_REV..HEAD"

# Get commit range with safer format
COMMITS=$(git log --pretty=format:'%H|%s|%b' "$REV_RANGE")

# Prepare temp files for categories
TMPDIR=$(mktemp -d)
CATEGORIES="feat fix chore docs style refactor perf test breaking"
for cat in $CATEGORIES; do
  > "$TMPDIR/$cat"
done

# Parse commits and write to category-specific files
echo "$COMMITS" | awk -v tmpdir="$TMPDIR" '
  BEGIN { FS="|"; }
  {
    sha=$1; subject=$2; body=$3;
    if (match(subject, /^([a-zA-Z]+): /, m)) {
      type=m[1];
      msg=substr(subject, RLENGTH+1);
      if (type ~ /^(feat|fix|chore|docs|style|refactor|perf|test)$/) {
        print "- " msg >> tmpdir "/" type;
      }
    }
    if (body ~ /BREAKING CHANGE:/) {
      n = split(body, lines, "\n");
      for (i=1; i<=n; i++) {
        if (lines[i] ~ /BREAKING CHANGE:/) {
          sub(/.*BREAKING CHANGE:[ ]*/, "", lines[i]);
          print "- " lines[i] " (`" sha "`) " >> tmpdir "/breaking";
        }
      }
    }
  }
'

# Output grouped commit entries with markdown headers
for cat in $CATEGORIES; do
  if [ -s "$TMPDIR/$cat" ]; then
    if [ "$FORMAT" = "md" ]; then
      printf "%s %s\n" "$(printf '#%.0s' $(seq 1 "$HEADER_LEVEL"))" "$cat"
    fi
    cat "$TMPDIR/$cat"
  fi
done

# Clean up temporary directory
rm -rf "$TMPDIR"
