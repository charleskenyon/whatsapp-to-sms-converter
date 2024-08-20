import { S3Client } from '@aws-sdk/client-s3';
import { SNSClient } from '@aws-sdk/client-sns';

const { AWS_REGION, WHATSAPP_MEDIA_BUCKET, WHATSAPP_SNS_SMS_TOPIC_ARN } =
  process.env;

const baseConfig = { region: AWS_REGION };

const AWS = {
  s3Client: new S3Client({ ...baseConfig }),
  snsClient: new SNSClient({ ...baseConfig }),
};

export { AWS, WHATSAPP_MEDIA_BUCKET, WHATSAPP_SNS_SMS_TOPIC_ARN };
