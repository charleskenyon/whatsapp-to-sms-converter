import WAWebJS, { MessageTypes } from 'whatsapp-web.js';
import emojiStrip from 'emoji-strip';
import { getDigitalTime, messageConcatenator } from '../utils';
import { whatsappClient, cache } from '../constants';

const generator = messageConcatenator();
(async () => await generator.next())();

const messageHandler = async (message: WAWebJS.Message) => {
  const { body, from, timestamp } = message;
  const strippedBody = emojiStrip(body);
  const chat = await message.getChat();
  if (
    !chat.isMuted &&
    message.type !== MessageTypes.CALL_LOG &&
    strippedBody.length
  ) {
    const time = getDigitalTime(timestamp);
    const { name } = await whatsappClient.getContactById(from);
    await generator.next(`<${name} | ${time}> ${strippedBody}`);
    cache.set(name, from);
    console.log(`${from}: <${name} | ${time}> ${strippedBody}`);
  }
};

export default messageHandler;
