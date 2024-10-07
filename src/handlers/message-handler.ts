import WAWebJS from 'whatsapp-web.js';
import { twilioMessage } from '../utils';
import { whatsappClient, cache } from '../constants';

const messageHandler = async (message: WAWebJS.Message) => {
  const { body, from } = message;
  const { name } = await whatsappClient.getContactById(from);
  await twilioMessage(`<${name}> ${body}`);
  cache.set(name, from);
  console.log(`${from}: <${name}> ${body}`);
};

export default messageHandler;
