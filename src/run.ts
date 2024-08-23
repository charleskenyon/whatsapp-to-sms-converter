import { whatsappClient } from './constants';
import { qrHandler } from './event-handlers';

const start = 'start' as string;

console.log(start);

whatsappClient.on('ready', () => {
  console.log('Client is ready!');
});

whatsappClient.on('qr', qrHandler);

// Listening to all incoming messages
whatsappClient.on('message_create', (message) => {
  console.log(message.body);
});

whatsappClient.initialize();

// https://docs.github.com/en/actions/quickstart
// https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
