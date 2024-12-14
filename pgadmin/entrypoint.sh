#!/bin/sh

SERVERS_JSON_PATH="/pgadmin4/servers.json"
PGPASSFILE_PATH="$HOME/.pgpass"

# Ensure required environment variables are set
: "${POSTGRES_CONNDATOS_HOST:?Need to set POSTGRES_CONNDATOS_HOST}"
: "${POSTGRES_CONNDATOS_USER:?Need to set POSTGRES_CONNDATOS_USER}"
: "${POSTGRES_CONNDATOS_PASSWORD:?Need to set POSTGRES_CONNDATOS_PASSWORD}"
: "${POSTGRES_CONNDATOS_DB:?Need to set POSTGRES_CONNDATOS_DB}"
: "${POSTGRES_CONNDATOS_PORT:?Need to set POSTGRES_CONNDATOS_PORT}"

: "${POSTGRES_LMS_HOST:?Need to set POSTGRES_LMS_HOST}"
: "${POSTGRES_LMS_USER:?Need to set POSTGRES_LMS_USER}"
: "${POSTGRES_LMS_PASSWORD:?Need to set POSTGRES_LMS_PASSWORD}"
: "${POSTGRES_LMS_DB:?Need to set POSTGRES_LMS_DB}"
: "${POSTGRES_LMS_PORT:?Need to set POSTGRES_LMS_PORT}"

# Create the .pgpass file for password
echo "Creating pgpass file at $PGPASSFILE_PATH"
echo "${POSTGRES_CONNDATOS_HOST}:${POSTGRES_CONNDATOS_PORT}:*:${POSTGRES_CONNDATOS_USER}:${POSTGRES_CONNDATOS_PASSWORD}" > "$PGPASSFILE_PATH"
echo "${POSTGRES_LMS_HOST}:5432:*:${POSTGRES_LMS_USER}:${POSTGRES_LMS_PASSWORD}" >> "$PGPASSFILE_PATH"
chmod 600 "$PGPASSFILE_PATH"
echo "pgpass file created successfully."

# Creation of servers.json file
echo "Creating servers.json file in $SERVERS_JSON_PATH"
cat <<EOF >"$SERVERS_JSON_PATH"
{
  "Servers": {
    "1": {
      "Name": "${POSTGRES_CONNDATOS_DB}",
      "Group": "Conndatos Servers",
      "Host": "${POSTGRES_CONNDATOS_HOST}",
      "Port": ${POSTGRES_CONNDATOS_PORT},
      "MaintenanceDB": "${POSTGRES_CONNDATOS_DB}",
      "Username": "${POSTGRES_CONNDATOS_USER}",
      "PassFile": "$PGPASSFILE_PATH",
      "SSLMode": "prefer"
    },
    "2": {
      "Name": "${POSTGRES_LMS_DB}",
      "Group": "LMS System Servers",
      "Host": "${POSTGRES_LMS_HOST}",
      "Port": ${POSTGRES_LMS_PORT},
      "MaintenanceDB": "${POSTGRES_LMS_DB}",
      "Username": "${POSTGRES_LMS_USER}",
      "PassFile": "$PGPASSFILE_PATH",
      "SSLMode": "prefer"
    }
  }
}
EOF

echo "$SERVERS_JSON_PATH file created successfully."

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
