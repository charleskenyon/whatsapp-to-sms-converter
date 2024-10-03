import express from 'express';
import { Client } from 'whatsapp-web.js';
import { S3Client } from '@aws-sdk/client-s3';
import { SNSClient } from '@aws-sdk/client-sns';
import TwilioSDK from 'twilio';
import NodeCache from 'node-cache';

const {
  AWS_REGION,
  WHATSAPP_MEDIA_BUCKET,
  TWILIO_ACCOUNT_SID,
  TWILIO_AUTH_TOKEN,
  TWILIO_NUMBER,
  RECEIVING_PHONE_NUMBER,
  CONTAINER_PORT,
} = process.env;

console.log(
  'ENV!!!___',
  AWS_REGION,
  WHATSAPP_MEDIA_BUCKET,
  TWILIO_ACCOUNT_SID,
  TWILIO_AUTH_TOKEN,
  TWILIO_NUMBER,
  RECEIVING_PHONE_NUMBER,
  CONTAINER_PORT,
  'WORKINGs'
);

const baseConfig = { region: AWS_REGION };

const AWS = {
  s3Client: new S3Client({ ...baseConfig }),
  snsClient: new SNSClient({ ...baseConfig }),
};

const whatsappClient = new Client({
  qrMaxRetries: 10,
  puppeteer: {
    args: [
      '--no-sandbox',
      '--disable-setuid-sandbox',
      '--disable-dev-shm-usage',
    ],
  },
});

const twilioClient = new (TwilioSDK as any)(
  TWILIO_ACCOUNT_SID,
  TWILIO_AUTH_TOKEN
) as TwilioSDK.Twilio;

const app = express();

const cache = new NodeCache();

export {
  AWS,
  WHATSAPP_MEDIA_BUCKET,
  TWILIO_NUMBER,
  RECEIVING_PHONE_NUMBER,
  CONTAINER_PORT,
  whatsappClient,
  twilioClient,
  app,
  cache,
};
