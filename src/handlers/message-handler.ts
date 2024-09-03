import WAWebJS from 'whatsapp-web.js';
import { twilioMessage } from '../utils';
import { cache } from '../constants';

const messageHandler = (
  message: WAWebJS.Message & { _data: { notifyName: string } }
) => {
  const {
    body,
    from,
    _data: { notifyName },
  } = message;

  twilioMessage(`<${notifyName}> ${body}`);
  cache.set(notifyName, from);
};

export default messageHandler;
