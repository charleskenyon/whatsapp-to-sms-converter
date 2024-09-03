import qrImage from 'qr-image';
import { uploadImageS3, generatePresignedUrl, twilioMessage } from '../utils';

const qrHandler = async (qr: string) => {
  const s3key = `qr/qr-${new Date().valueOf()}.png`;
  const image = qrImage.imageSync(qr, { type: 'png' });
  await uploadImageS3({ key: s3key, image });
  const signedQrUrl = await generatePresignedUrl(s3key);
  console.log('signedQrUrl', signedQrUrl);
  await twilioMessage(`QR: ${signedQrUrl}`);
  return;
};

export default qrHandler;

// https://www.twilio.com/docs/serverless/functions-assets/quickstart/receive-sms#respond-with-mms-media-from-an-http-request
// https://www.twilio.com/en-us/blog/how-to-receive-and-respond-to-a-text-message-with-node-js-express-and-twilio-html
// https://medium.com/@adybagus/automated-reply-with-whatsapp-web-js-express-js-299eee4e57b1
// twilio phone-numbers:update <your Twilio phone number> --sms-url "http://localhost:3000/sms-reply"
// https://www.twilio.com/docs/twilio-cli/quickstart
// https://www.twilio.com/docs/messaging/tutorials/how-to-receive-and-reply/node-js
// twilio phone-numbers:update "+447402542325" --sms-url="http://localhost:3000/sms" -l debug
