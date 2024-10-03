# whatsapp-to-sms-converter

Application converts Whatsapp messages to sms and forwards them back and forth using Twilio. The idea being that Whatsapp messages can be sent and received on a dumb phone that is unable to run Whatsapp.

The application is designed to be run 24/7 on a ECS Fargate container and requires an initial login to the Whatsapp web app using a QR code on first startup. The [whatsapp-web.js](https://wwebjs.dev/) NodeJS client then manages incoming and outgoing Whatsapp messages on the ECS container and converts them to and from sms messages that are handled using the Twilio client.

## setup

install terraform, twilio-cli, ngrok, nodemon

`npx husky` - init husky for pre-commit hooks

---

`npm run dev` - run api locally with ts-node

`npm run dev-docker` - run api locally inside docker container
