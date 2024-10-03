import bodyParser from 'body-parser';
import { whatsappClient, app, CONTAINER_PORT } from './constants';
import { qrHandler, messageHandler, smsResponseHandler } from './handlers';

whatsappClient.on('ready', () => console.log('Whatsapp client is ready!'));

whatsappClient.on('qr', qrHandler);

whatsappClient.on('message_create', messageHandler);

whatsappClient.initialize();

console.log('WORKING!!34!');

app.post(
  '/sms',
  bodyParser.urlencoded({ extended: false }),
  smsResponseHandler
);

app.get('/health', (_req, res) => {
  res.status(200).json({ status: 'UP' });
});

app.listen(CONTAINER_PORT, () => {
  console.log(`app listening on port ${CONTAINER_PORT}`);
});
