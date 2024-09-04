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
  console.log('message response: ', messageResponse);

  const responseRegex = /^<([^>]+)>\s*(.*)$/;
  const [, name, response] = messageResponse.match(responseRegex);
  console.log('*', name, response);

  const contactId: string = cache.get(name) || (await getContactId(name));

  whatsappClient.sendMessage(contactId, response as unknown as string);

  const twiml = new Twilio.twiml.MessagingResponse();
  res.type('text/xml').send(twiml.toString());
};

export default smsResponseHandler;
