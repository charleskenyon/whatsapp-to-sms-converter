import Twilio from 'twilio';
import bodyParser from 'body-parser';
import { whatsappClient, app } from './constants';
// import { qrHandler } from './event-handlers';

const start = 'start' as string;

console.log(start);

whatsappClient.on('ready', () => {
  console.log('Client is ready!');
});

// whatsappClient.on('qr', qrHandler);

whatsappClient.on('message_create', (message) => {
  console.log('message_create', message.body);
});

app.use(bodyParser.urlencoded({ extended: false }));

app.get('/', (req, res) => {
  res.send('Hello World!');
});

app.post('/sms', (req, res) => {
  const {
    body: { Body: messageResponse },
  } = req;
  console.log('message response: ', messageResponse);

  const twiml = new Twilio.twiml.MessagingResponse();
  res.type('text/xml').send(twiml.toString());
});

whatsappClient.initialize();

app.listen(3000, () => {
  console.log('Example app listening on port 3000!');
});

// https://docs.github.com/en/actions/quickstart
// https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
// docker build --tag=whatsapp .
// docker run --rm -it -p 3000:3000 --env-file=.env -v ~/.aws:/root/.aws whatsapp
