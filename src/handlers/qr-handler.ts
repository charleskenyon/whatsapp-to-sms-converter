import qrImage from 'qr-image';
import { uploadImageS3, generatePresignedUrl, twilioMessage } from '../utils';

const qrHandler = async (qr: string) => {
  const s3key = `qr/qr-${new Date().valueOf()}.png`;
  const image = qrImage.imageSync(qr, { type: 'png' });
  await uploadImageS3({ key: s3key, image });
  const signedQrUrl = await generatePresignedUrl(s3key);
  console.log('signedQrUrl', signedQrUrl);
  await twilioMessage('QR code sent');
  return;
};

export default qrHandler;
