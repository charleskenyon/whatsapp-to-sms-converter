import WAWebJS, { MessageTypes } from 'whatsapp-web.js';
import { twilioMessage } from '../utils';
import { whatsappClient, cache } from '../constants';

const messageHandler = async (message: WAWebJS.Message) => {
  const { body, from } = message;
  const chat = await message.getChat();
  if (!chat.isMuted && message.type !== MessageTypes.CALL_LOG) {
    const { name } = await whatsappClient.getContactById(from);
    await twilioMessage(`<${name}> ${body}`);
    cache.set(name, from);
    console.log(`${from}: <${name}> ${body}`);
  }
};

export default messageHandler;
