app_name=OPS_TEST
app_version="1.5"
version_note="Fixed bug DEV-1234"
short_desc="This is a short description of the app" # limit 100 characters
long_desc="This is a long description of the app"

echo "[long=$long_desc]"
echo '[long='$long_desc']'
echo '[long='${long_desc}']'
