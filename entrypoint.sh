#!/bin/sh

SERVERS_JSON_PATH="/pgadmin4/servers.json"
PGPASSFILE="$HOME/.pgpass"

# Create the .pgpass file for password
echo "Creating pgpass file at $PGPASSFILE"
echo "${POSTGRES_HOST}:*:*:${POSTGRES_USER}:${POSTGRES_PASSWORD}" >"$PGPASSFILE"
chmod 600 $PGPASSFILE
# Removed cat $PGPASSFILE to avoid printing sensitive information
echo "pgpass file created successfully."

echo "Creating servers.json file in $SERVERS_JSON_PATH"
cat <<EOF >$SERVERS_JSON_PATH
{
    "Servers": {
        "1": {
            "Name": "${POSTGRES_DB}",
            "Group": "Conndatos Servers",
            "Host": "${POSTGRES_HOST}",
            "Port": ${POSTGRES_PORT},
            "MaintenanceDB": "${POSTGRES_DB}",
            "Username": "${POSTGRES_USER}",
            "PassFile": "${PGPASSFILE}",
            "SSLMode": "prefer"
        }
    }
}
EOF

echo "$SERVERS_JSON_PATH file created successfully."
# Removed cat $SERVERS_JSON_PATH to avoid printing sensitive information

# Clear cookies and sessions
echo "Clearing cookies and sessions..."
rm -rf /pgadmin4/sessions /pgadmin4/cookies
echo "Cookies and sessions cleared."

# Delete session cookie file
SESSION_COOKIE_FILE="/pgadmin4/.pgadmin4_session"
if [ -f "$SESSION_COOKIE_FILE" ]; then
    echo "Deleting session cookie file..."
    rm "$SESSION_COOKIE_FILE"
    echo "Session cookie file deleted."
fi

# Ensure session cookie is not persisted
echo "Clearing session cookie..."
unset pga4_session
echo "Session cookie cleared."

echo "Starting pgAdmin4..."
exec /entrypoint.sh
echo "pgAdmin4 started."
