#!/usr/bin/env bash
echo $GOOGLE_CREDENTIALS > google-credentials.json
export GOOGLE_APPLICATION_CREDENTIALS="google-credentials.json"

./backend/build/install/backend/bin/backend