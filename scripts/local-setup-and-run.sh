#!/bin/bash

cd ..

source .env

killall ngrok

sleep 1

ngrok http 3000 > /dev/null &

sleep 1

NGROK_URL=$(curl --silent http://127.0.0.1:4040/api/tunnels | jq -r '.tunnels[] | select(.proto == "https") | .public_url')

curl -X POST https://api.twilio.com/2010-04-01/Accounts/$TWILIO_ACCOUNT_SID/IncomingPhoneNumbers/$TWILIO_NUMBER_SID.json \
--data-urlencode "SmsUrl=$NGROK_URL/sms" \
-u $TWILIO_ACCOUNT_SID:$TWILIO_AUTH_TOKEN

echo 

if [ "$1" == "docker" ]; then
    docker build --tag=whatsapp .
    docker run --rm -it -p 3000:3000 --env-file=.env -v ~/.aws:/root/.aws whatsapp
else
    nodemon --exec ts-node -r dotenv/config --project ./tsconfig.json --ext "ts" src/run.ts
fi
