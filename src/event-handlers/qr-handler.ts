import {
  PutObjectCommand,
  PutObjectAclCommandOutput,
} from '@aws-sdk/client-s3';
import QRCode from 'qrcode';
import fs from 'fs';
import { AWS, WHATSAPP_MEDIA_BUCKET } from '../constants';

const qrHandler = async (qr: string): Promise<PutObjectAclCommandOutput> => {
  console.log('qr', qr);

  const qrKey = `qr/${new Date().valueOf()}.png`;
  const qrFilePath = `./${qrKey}`;

  console.log(qrKey, qrFilePath);

  QRCode.toFile(qrFilePath, qr, {
    type: 'png',
    width: 300,
  });

  const fileContent = fs.readFileSync(qrFilePath);

  const response = await AWS.s3Client.send(
    new PutObjectCommand({
      Bucket: WHATSAPP_MEDIA_BUCKET,
      Key: qrKey,
      Body: fileContent,
      ContentType: 'image/png',
    })
  );

  return response;
};

export default qrHandler;
