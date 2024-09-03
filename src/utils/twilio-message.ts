import {
  TWILIO_NUMBER,
  twilioClient,
  RECEIVING_PHONE_NUMBER,
} from '../constants';

const twilioMessage = (message: string) =>
  twilioClient.messages.create({
    body: message,
    from: TWILIO_NUMBER,
    to: RECEIVING_PHONE_NUMBER,
  });

export default twilioMessage;
