import Twilio from 'twilio';
import { Request, Response } from 'express';
import { getContactId } from '../utils';
import { cache, whatsappClient } from '../constants';

const smsResponseHandler = async (
  req: Request,
  res: Response
): Promise<void> => {
  const {
    body: { Body: messageResponse },
  } = req;

  const responseRegex = /^<([^>]+)>\s*(.*)$/;
  const [, name, response] = messageResponse.match(responseRegex);

  const chatId: string = cache.get(name) || (await getContactId(name));

  whatsappClient.sendMessage(chatId, response as unknown as string);
  console.log(`sent to ${chatId}: ${response}`);

  const twiml = new Twilio.twiml.MessagingResponse();
  res.type('text/xml').send(twiml.toString());
};

export default smsResponseHandler;
