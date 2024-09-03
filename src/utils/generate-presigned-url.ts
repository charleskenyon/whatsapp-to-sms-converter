import { GetObjectCommand } from '@aws-sdk/client-s3';
import { getSignedUrl } from '@aws-sdk/s3-request-presigner';
import { AWS, WHATSAPP_MEDIA_BUCKET } from '../constants';

const generatePresignedUrl = (key: string): Promise<string> =>
  getSignedUrl(
    AWS.s3Client,
    new GetObjectCommand({
      Bucket: WHATSAPP_MEDIA_BUCKET,
      Key: key,
    }),
    {
      expiresIn: 60,
    }
  );

export default generatePresignedUrl;
