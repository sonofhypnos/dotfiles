#!/bin/bash -
#title          :backup-urls.sh
#description    :Backs up all the urls I visit through firefox and chrome.
#Should be updated in the future when we have more file storage to also archive
#these urls.
#author         :Tassilo Neubauer
#date           :20250507
#version        :0.1
#usage          :./backup-urls.sh
#notes          :
#bash_version   :5.2.21(1)-release
#============================================================================

url_path="/home/tassilo/repos/urls"

# Handle chrome:
CHROME_PID=$(pgrep -f 'chrome' | head -n1)

# Pause Chrome
kill -STOP "$CHROME_PID"

# Copy database safely
cp ~/.config/google-chrome/Default/History /tmp/History_chrome_copy

# Resume Chrome
kill -CONT "$CHROME_PID"

sqlite3 -csv /tmp/History_chrome_copy "
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
" >"$url_path/chrome_history_with_metadata.csv"





# NOTE: in practice I prefer to save the first visit to a website (which is more interesting, for say seeing when I first discovered something)
sqlite3 -csv ~/.mozilla/firefox/*.default-release/places.sqlite "
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
" >"$url_path/firefox_history_first_visit.csv"



cd /home/tassilo/repos/urls || exit 1
# commit the changes to the git repository
git add .
git commit -m "Updated URLs from Chrome and Firefox"

# NOTE: In a second step we would also like to save all of the file data, but for now we are just going to save the urls, so they are not lost to the void
#!/bin/bash
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
