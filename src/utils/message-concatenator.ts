import { twilioMessage } from '.';

async function* messageConcatenator( // send messages in batches 1600 characters, flush every five minutes
  maxCharacterLength = 1600,
  flushMsgsInterval = 1000 * 300
) {
  let concatenatedMsgs = '';

  setInterval(async () => {
    if (concatenatedMsgs.length) {
      await twilioMessage(concatenatedMsgs);
      concatenatedMsgs = '';
    }
  }, flushMsgsInterval);

  while (true) {
    const inputMsg: string = yield concatenatedMsgs;
    const predictedLength = [concatenatedMsgs, ' ', inputMsg.trim()].reduce(
      (ac, cv) => (ac += cv.length),
      0
    );

    if (predictedLength > maxCharacterLength) {
      await twilioMessage(concatenatedMsgs);
      console.log('SENT: ', concatenatedMsgs);
      concatenatedMsgs = inputMsg.trim();
    } else {
      concatenatedMsgs += ' ' + inputMsg.trim();
    }
  }
}

export default messageConcatenator;
