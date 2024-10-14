import { twilioMessage } from '.';

async function* messageConcatenator( // send messages in batches 1600 characters, flush every five minutes
  maxCharacterLength = 1600,
  flushMsgsInterval = 1000 * 300
) {
  let concatenatedMsgs = '';

  setInterval(async () => {
    if (concatenatedMsgs.length) {
      console.log('FLUSH', concatenatedMsgs);
      await twilioMessage(concatenatedMsgs);
      concatenatedMsgs = '';
    }
  }, flushMsgsInterval);

  while (true) {
    const inputMsg: string = yield concatenatedMsgs;
    console.log('new run');
    const predictedLength = [concatenatedMsgs, ' ', inputMsg.trim()].reduce(
      (ac, cv) => (ac += cv.length),
      0
    );
    console.log(concatenatedMsgs.length);
    if (predictedLength > maxCharacterLength) {
      console.log('GREATER THAN 1600!!');
      await twilioMessage(concatenatedMsgs);
      concatenatedMsgs = inputMsg.trim();
    } else {
      console.log('else');
      concatenatedMsgs += ' ' + inputMsg.trim();
      console.log('concatenatedMsgs', concatenatedMsgs);
    }
  }
}

export default messageConcatenator;
