import { PutObjectCommand, PutObjectCommandOutput } from '@aws-sdk/client-s3';
import { AWS, WHATSAPP_MEDIA_BUCKET } from '../constants';

const uploadImageS3 = ({
  key,
  image,
}: {
  key: string;
  image: string | Buffer;
}): Promise<PutObjectCommandOutput> =>
  AWS.s3Client.send(
    new PutObjectCommand({
      Bucket: WHATSAPP_MEDIA_BUCKET,
      Key: key,
      Body: image,
      ContentType: 'image/png',
    })
  );

export default uploadImageS3;
