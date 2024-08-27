import { PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import qrImage from 'qr-image';
import {
  AWS,
  WHATSAPP_MEDIA_BUCKET,
  TWILIO_NUMBER,
  twilioClient,
  RECEIVING_PHONE_NUMBER,
} from '../constants';

const qrHandler = async (qr: string) => {
  console.log('qr', qr);

  const key = `qr/qr-${new Date().valueOf()}.png`;
  const image = qrImage.imageSync(qr, { type: 'png' });

  // Post QR to S3
  const s3Response = await AWS.s3Client.send(
    new PutObjectCommand({
      Bucket: WHATSAPP_MEDIA_BUCKET,
      Key: key,
      Body: image,
      ContentType: 'image/png',
    })
  );

  // Generate the presigned URL
  const signedUrl = await getSignedUrl(
    AWS.s3Client,
    new GetObjectCommand({
      Bucket: WHATSAPP_MEDIA_BUCKET,
      Key: key,
    }),
    {
      expiresIn: 60,
    }
  );

  console.log('response', s3Response, signedUrl);

  console.log({
    body: `QR: ${signedUrl}`,
    from: TWILIO_NUMBER,
    to: RECEIVING_PHONE_NUMBER,
  });

  const message = await twilioClient.messages.create({
    body: `QR: ${signedUrl}`, // The message body
    from: TWILIO_NUMBER, // Replace with your Twilio number
    to: RECEIVING_PHONE_NUMBER, // Replace with the recipient's phone number (E.164 format)
  });

  console.log('message', message);

  // throw new Error('broken');
  return;
};

export default qrHandler;

// https://www.twilio.com/docs/serverless/functions-assets/quickstart/receive-sms#respond-with-mms-media-from-an-http-request
// https://www.twilio.com/en-us/blog/how-to-receive-and-respond-to-a-text-message-with-node-js-express-and-twilio-html
// https://medium.com/@adybagus/automated-reply-with-whatsapp-web-js-express-js-299eee4e57b1
// twilio phone-numbers:update <your Twilio phone number> --sms-url "http://localhost:3000/sms-reply"
// https://www.twilio.com/docs/twilio-cli/quickstart
