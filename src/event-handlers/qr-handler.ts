import { PutObjectCommand, GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
// import { PublishCommand } from '@aws-sdk/client-sns';
import qrImage from 'qr-image';
import Twilio from 'twilio';
import {
  AWS,
  WHATSAPP_MEDIA_BUCKET,
  // WHATSAPP_SNS_SMS_TOPIC_ARN,
} from '../constants';

const accountSid = process.env.TWILIO_ACCOUNT_SID;
const authToken = process.env.TWILIO_AUTH_TOKEN;
const client = new (Twilio as any)(accountSid, authToken);

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

  // const snsResponse = await AWS.snsClient.send(
  //   new PublishCommand({
  //     // TopicArn: WHATSAPP_SNS_SMS_TOPIC_ARN,
  //     TopicArn:
  //       'arn:aws:sns:eu-west-2:493527389854:whatsapp-to-sms-converter-sns-sms-topic',
  //     Message: `QR: ${signedUrl}`,
  //     Subject: 'whatsapp-to-sms-converter',
  //   })
  // );

  console.log('response', s3Response, signedUrl);
  // console.log('snsResponse', snsResponse);

  const message = await client.messages.create({
    body: `QR: ${signedUrl}`, // The message body
    from: process.env.TWILIO_NUMBER, // Replace with your Twilio number
    to: process.env.PHONE_NUMBER, // Replace with the recipient's phone number (E.164 format)
  });

  console.log('message', message);

  throw new Error('broken');
  // return response;
};

export default qrHandler;

// docker run --rm -it -e AWS_REGION=eu-west-2 -e WHATSAPP_MEDIA_BUCKET=whatsapp-to-sms-converter-media -v ~/.aws:/root/.aws whatsapp
// use Twilio
