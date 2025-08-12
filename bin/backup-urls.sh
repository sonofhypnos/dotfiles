#!/usr/bin/env bash
#title          :backup-urls.sh
#description    :Backs up all the urls I visit through firefox and chrome.
#Should be updated in the future when we have more file storage to also archive
#these urls.
#author         :Tassilo Neubauer
#date           :20250507
#version        :0.2
#usage          :./backup-urls.sh
#notes          :
#bash_version   :5.2.21(1)-release
#============================================================================

set -euo pipefail

url_path="/home/tassilo/repos/urls"

# Ensure output dir exists
mkdir -p "$url_path"

# Check required tools early
for cmd in sqlite3 git pgrep; do
  command -v "$cmd" >/dev/null 2>&1 || { echo "Missing dependency: $cmd" >&2; exit 1; }
done

cache_dir="$(mktemp -d)"
trap 'rm -rf "$cache_dir"' EXIT

# -----------------------
# Handle chrome:
# -----------------------
CHROME_PID="$(pgrep -f 'chrome' | head -n1 || true)"

if [[ -n "${CHROME_PID}" ]]; then
  # Pause Chrome
  kill -STOP "$CHROME_PID" 2>/dev/null || true
fi

# Copy database safely
if [[ -f "$HOME/.config/google-chrome/Default/History" ]]; then
  cp "$HOME/.config/google-chrome/Default/History" "$cache_dir/History_chrome_copy" || { echo "Chrome History copy failed"; exit 1; }
else
  echo "Chrome history DB not found; skipping Chrome." >&2
fi

# Resume Chrome
if [[ -n "${CHROME_PID}" ]]; then
  kill -CONT "$CHROME_PID" 2>/dev/null || true
fi

# Export Chrome history (if we had a DB)
if [[ -f "$cache_dir/History_chrome_copy" ]]; then
  sqlite3 -csv "$cache_dir/History_chrome_copy" "
SELECT
  urls.url,
  urls.title,
  urls.visit_count,
  datetime(MIN(visits.visit_time)/1000000 + strftime('%s','1601-01-01'), 'unixepoch') AS first_visited,
  datetime(MAX(visits.visit_time)/1000000 + strftime('%s','1601-01-01'), 'unixepoch') AS last_visited
FROM urls
JOIN visits ON urls.id = visits.url
WHERE urls.url LIKE 'http%'
GROUP BY urls.url
ORDER BY urls.url;
" >"$url_path/chrome_history_with_metadata.csv" || { echo "SQLite extraction for Chrome failed"; exit 1; }
fi

# -----------------------
# Handle Firefox (all profiles):
# -----------------------

# Locate all Firefox profiles via profiles.ini (covers *.default-release, *.default, ESR, custom)
profiles_ini="$HOME/.mozilla/firefox/profiles.ini"
declare -a ff_profiles=()

if [[ -f "$profiles_ini" ]]; then
  # Extract Path= lines; handle IsRelative=1 vs absolute paths
  # We read in blocks to respect IsRelative for the following Path
  current_is_relative=1
  while IFS= read -r line; do
    case "$line" in
      IsRelative=*)
        val="${line#IsRelative=}"
        if [[ "$val" == "0" ]]; then current_is_relative=0; else current_is_relative=1; fi
        ;;
      Path=*)
        p="${line#Path=}"
        if [[ $current_is_relative -eq 1 ]]; then
          ff_profiles+=("$HOME/.mozilla/firefox/$p")
        else
          ff_profiles+=("$p")
        fi
        ;;
    esac
  done < <(sed -n '/^\[Profile[0-9]\+\]/,/^\[/p' "$profiles_ini")

  # Fallback: also include any directories that look like profiles if profiles.ini is sparse
  while IFS= read -r d; do
    ff_profiles+=("$d")
  done < <(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default*" -print 2>/dev/null || true)
else
  # No profiles.ini; try globbing known patterns
  while IFS= read -r d; do
    ff_profiles+=("$d")
  done < <(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default*" -print 2>/dev/null || true)
fi

# De-duplicate profile list
if ((${#ff_profiles[@]})); then
  mapfile -t ff_profiles < <(printf '%s\n' "${ff_profiles[@]}" | awk 'NF' | sort -u)
fi

# Pause Firefox once while copying all DBs (if running)
FIREFOX_PID="$(pgrep -f 'firefox' | head -n1 || true)"
if [[ -n "${FIREFOX_PID}" ]]; then
  kill -STOP "$FIREFOX_PID" 2>/dev/null || true
fi

declare -a copied_places=()
for prof in "${ff_profiles[@]}"; do
  db="$prof/places.sqlite"
  if [[ -f "$db" ]]; then
    # Copy each places.sqlite to cache with a unique name
    tag="$(basename "$prof")"
    cp "$db" "$cache_dir/places_${tag}.sqlite" || { echo "Copy failed for $db"; exit 1; }
    copied_places+=("$cache_dir/places_${tag}.sqlite::$tag")
  fi
done

# Resume Firefox
if [[ -n "${FIREFOX_PID}" ]]; then
  kill -CONT "$FIREFOX_PID" 2>/dev/null || true
fi

# Export from all copied Firefox DBs into a combined CSV with a profile column
ff_out="$url_path/firefox_history_first_visit_all_profiles.csv"
# Write header
printf 'url,title,visit_count,first_visited,profile\n' > "$ff_out"

if ((${#copied_places[@]})); then
  for pair in "${copied_places[@]}"; do
    db="${pair%%::*}"
    tag="${pair##*::}"
    # We wrap each row and append the profile tag as a literal CSV field.
    # To avoid csv quoting pain, rely on sqlite's CSV + printf for the trailing field.
    tmp_csv="$cache_dir/${tag}.csv"
    sqlite3 -csv "$db" "
SELECT
  moz_places.url,
  moz_places.title,
  moz_places.visit_count,
  datetime(MIN(moz_historyvisits.visit_date)/1000000, 'unixepoch', 'localtime') AS first_visited
FROM moz_places
JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id
WHERE moz_places.url LIKE 'http%'
GROUP BY moz_places.url
ORDER BY moz_places.url;
" > "$tmp_csv" || { echo "SQLite extraction failed for profile $tag"; exit 1; }

    # Append with profile column; handle empty files gracefully
    if [[ -s "$tmp_csv" ]]; then
      # Add ,profile to each line; if lines may contain CRLF, strip CR
      awk -v prof="$tag" 'BEGIN{FS=OFS=""} NR==1 && $0 ~ /^url,title,visit_count,first_visited$/ {next} {gsub("\r",""); print $0,",",prof}' "$tmp_csv" >> "$ff_out"
    fi
  done
else
  echo "No Firefox places.sqlite found; skipping Firefox export." >&2
fi

# -----------------------
# Commit to git if there are changes
# -----------------------
cd "$url_path" || exit 1
git add -A

if git diff --cached --quiet; then
  echo "No changes to commit."
else
  git commit -m "Updated URLs from Chrome and Firefox ($(date -Iseconds))"
fi

# NOTE: In a second step we would also like to save all of the file data, but for now we are just going to save the urls, so they are not lost to the void
#!/usr/bin/env bash
# Simplified link archiving script based on Gwern's `linkArchive.sh`
# This version saves a deduplicated, timestamped archive of URLs as HTML or PDF
# Adapt to your folder structure and tooling setup where noted

# ### --- CONFIGURATION SECTION --- ###

# # Set your desired archive base directory
# ARCHIVE_DIR="$HOME/web-archive"

# # User agent to use for remote requests (mimic Firefox)
# USER_AGENT="Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:125.0) Gecko/20100101 Firefox/124.0"

# # Path to your SingleFile CLI Docker container, or skip if you want to add your own method later
# USE_SINGLEFILE_DOCKER=true # set to false if using singlefile locally

# ### --- URL INPUT --- ###

# URL="$1"
# if [[ -z "$URL" ]]; then
#     echo "Usage: $0 <url>" >&2
#     exit 1
# fi

# # Clean the URL for deduplication (remove common tracking/query params and fragments)
# CLEAN_URL=$(echo "$URL" |
#     sed -E 's/[?&](utm_[^=]+|ref|fbclid|gclid|mc_cid|mc_eid)=[^&]*//g' |
#     sed -E 's/[?&]+$//' |
#     cut -d '#' -f 1)

# # Create hash for deduplication
# HASH=$(echo -n "$CLEAN_URL" | sha1sum | cut -d ' ' -f1)
# DOMAIN=$(echo "$CLEAN_URL" | awk -F[/:] '{print $4}')
# OUTDIR="$ARCHIVE_DIR/$DOMAIN"
# mkdir -p "$OUTDIR"

# # Set target output filenames
# HTML_OUT="$OUTDIR/$HASH.html"
# PDF_OUT="$OUTDIR/$HASH.pdf"

# # Check if file already exists
# if [[ -f "$HTML_OUT" || -f "$PDF_OUT" ]]; then
#     echo "Already archived: $HTML_OUT or $PDF_OUT"
#     exit 0
# fi

# ### --- MIME DETECTION --- ###
# MIME_TYPE=$(curl --max-filesize 200000000 --user-agent "$USER_AGENT" --head -sL -w '%{content_type}' -o /dev/null "$URL")

# if [[ "$MIME_TYPE" == application/pdf* || "$URL" =~ \.pdf$ ]]; then
#     echo "Detected PDF. Downloading..."
#     curl -L "$URL" -o "$PDF_OUT"
#     # Optional: add OCR or compression here later
#     echo "Saved to $PDF_OUT"
#     exit 0
# fi

# ### --- ARCHIVING HTML VIA SINGLEFILE --- ###
# if $USE_SINGLEFILE_DOCKER; then
#     echo "Archiving HTML with SingleFile Docker..."
#     docker run --rm --network="host" singlefile "$URL" >"$HTML_OUT"
# else
#     echo "TODO: Add support for local singlefile CLI or Puppeteer here." >&2
#     exit 2
# fi

# if [[ -f "$HTML_OUT" && $(stat -c%s "$HTML_OUT") -ge 1024 ]]; then
#     echo "Archived to $HTML_OUT"
# else
#     echo "Archiving failed or file too small." >&2
#     rm -f "$HTML_OUT"
#     exit 3
# fi
