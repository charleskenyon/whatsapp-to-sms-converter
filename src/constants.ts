import { S3Client } from '@aws-sdk/client-s3';

const { AWS_REGION, WHATSAPP_MEDIA_BUCKET } = process.env;

const AWS = {
  s3Client: new S3Client({ region: AWS_REGION }),
};

export { AWS, WHATSAPP_MEDIA_BUCKET };
