import { Client } from 'whatsapp-web.js';
import { S3Client } from '@aws-sdk/client-s3';
import { SNSClient } from '@aws-sdk/client-sns';
import Twilio from 'twilio';

const {
  AWS_REGION,
  WHATSAPP_MEDIA_BUCKET,
  WHATSAPP_SNS_SMS_TOPIC_ARN,
  TWILIO_ACCOUNT_SID,
  TWILIO_AUTH_TOKEN,
  TWILIO_NUMBER,
  RECEIVING_PHONE_NUMBER,
} = process.env;

const baseConfig = { region: AWS_REGION };

const AWS = {
  s3Client: new S3Client({ ...baseConfig }),
  snsClient: new SNSClient({ ...baseConfig }),
};

const whatsappClient = new Client({
  qrMaxRetries: 10,
  puppeteer: {
    args: ['--no-sandbox'],
  },
});

const twilioClient = new (Twilio as any)(TWILIO_ACCOUNT_SID, TWILIO_AUTH_TOKEN);

export {
  AWS,
  WHATSAPP_MEDIA_BUCKET,
  WHATSAPP_SNS_SMS_TOPIC_ARN,
  TWILIO_NUMBER,
  RECEIVING_PHONE_NUMBER,
  whatsappClient,
  twilioClient,
};
