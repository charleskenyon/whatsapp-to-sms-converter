import bodyParser from 'body-parser';
import { whatsappClient, app } from './constants';
import { qrHandler, messageHandler, smsResponseHandler } from './handlers';

whatsappClient.on('ready', () => console.log('Whatsapp client is ready!'));

whatsappClient.on('qr', qrHandler);

whatsappClient.on('message_create', messageHandler);

whatsappClient.initialize();

app.post(
  '/sms',
  bodyParser.urlencoded({ extended: false }),
  smsResponseHandler
);

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'UP' });
});

app.listen(3000, () => {
  console.log('Example app listening on port 3000!');
});

// https://docs.github.com/en/actions/quickstart
// https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
// docker build --tag=whatsapp .
// docker run --rm -it -p 3000:3000 --env-file=.env -v ~/.aws:/root/.aws whatsapp
