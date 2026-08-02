#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="$SCRIPT_DIR/docker-compose.yml"
TOKEN_FILE="$SCRIPT_DIR/.sonar_token"
PLUGIN_DIR="$SCRIPT_DIR/plugins"
PLUGIN_JAR="$PLUGIN_DIR/sonar-flutter-plugin-0.5.2.jar"
PLUGIN_URL="https://github.com/insideapp-fr/sonar-flutter/releases/download/0.5.2/sonar-flutter-plugin-0.5.2.jar"
SONAR_URL="http://localhost:9000"
ADMIN_PASS="Sonar_local_1"

# Download plugin if needed
if [ ! -f "$PLUGIN_JAR" ]; then
  echo "Downloading sonar-flutter plugin..."
  mkdir -p "$PLUGIN_DIR"
  if ! curl -fL "$PLUGIN_URL" -o "$PLUGIN_JAR"; then
    rm -f "$PLUGIN_JAR"
    echo "Error: failed to download plugin from $PLUGIN_URL"
    exit 1
  fi
fi

# Start SonarQube and wait for healthy
echo "Starting SonarQube..."
docker compose -f "$COMPOSE_FILE" up -d --wait sonarqube sonardb

# Set up auth token on first run
if [ ! -s "$TOKEN_FILE" ]; then
  echo "First run: setting up admin and generating token..."
  curl -s -X POST "$SONAR_URL/api/users/change_password" \
    -u "admin:admin" \
    -d "login=admin&previousPassword=admin&password=$ADMIN_PASS" \
    -o /dev/null || true

  # Find the working admin password (check the valid field, not just HTTP status)
  working_pass=""
  for pass in "$ADMIN_PASS" "admin"; do
    valid=$(curl -s -u "admin:$pass" "$SONAR_URL/api/authentication/validate" \
      | python3 -c "import sys,json; print(json.load(sys.stdin).get('valid', False))" 2>/dev/null || echo "False")
    [ "$valid" = "True" ] && working_pass="$pass" && break
  done

  if [ -z "$working_pass" ]; then
    echo "Error: cannot authenticate with SonarQube admin"
    exit 1
  fi

  # Revoke any existing token, then generate a fresh one
  curl -s -X POST "$SONAR_URL/api/user_tokens/revoke" \
    -u "admin:$working_pass" \
    -d "login=admin&name=local-scan" \
    -o /dev/null || true

  response=$(curl -s -X POST "$SONAR_URL/api/user_tokens/generate" \
    -u "admin:$working_pass" \
    -d "name=local-scan&type=USER_TOKEN")
  token=$(echo "$response" | python3 -c "import sys,json; print(json.load(sys.stdin)['token'])" 2>/dev/null || true)

  if [ -z "$token" ]; then
    echo "Error: failed to generate a token. Last API response:"
    echo "$response"
    exit 1
  fi

  echo "$token" > "$TOKEN_FILE"
fi

# Run flutter reports then scanner (dependency chain handled by compose)
echo "Running scan..."
SONAR_TOKEN="$(cat "$TOKEN_FILE")" \
  docker compose -f "$COMPOSE_FILE" --profile scan run --rm sonar-scanner
