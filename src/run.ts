import { Client } from 'whatsapp-web.js';
import { qrHandler } from './event-handlers';

const start = 'start' as string;

console.log(start);

const client = new Client({
  qrMaxRetries: 10,
  puppeteer: {
    args: ['--no-sandbox'],
  },
});

client.on('ready', () => {
  console.log('Client is ready!');
});

client.on('qr', qrHandler);

// Listening to all incoming messages
client.on('message_create', (message) => {
  console.log(message.body);
});

client.initialize();

// https://docs.github.com/en/actions/quickstart
// https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions
