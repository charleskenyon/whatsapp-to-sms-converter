import WAWebJS from 'whatsapp-web.js';
import { twilioMessage } from '../utils';
import { whatsappClient, cache } from '../constants';

const messageHandler = async (message: WAWebJS.Message) => {
  console.log('message', message);
  const { body, from } = message;
  const { name } = await whatsappClient.getContactById(from);
  console.log('name', name);
  await twilioMessage(`<${name}> ${body}`);
  cache.set(name, from);
};

export default messageHandler;
