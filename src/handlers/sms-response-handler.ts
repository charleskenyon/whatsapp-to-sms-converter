import Twilio from 'twilio';
import { Request, Response } from 'express';

const smsResponseHandler = (req: Request, res: Response): void => {
  const {
    body: { Body: messageResponse },
  } = req;
  console.log('message response: ', messageResponse);

  const twiml = new Twilio.twiml.MessagingResponse();
  res.type('text/xml').send(twiml.toString());
};

export default smsResponseHandler;
