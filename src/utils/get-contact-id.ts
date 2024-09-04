import { whatsappClient } from '../constants';

const getContactId = async (name: string) => {
  console.log('cache not hit');
  const contacts = await whatsappClient.getContacts();
  console.log(
    'contacts',
    contacts.map(({ name }) => name)
  );
  const [contact] = contacts.filter(
    ({ name: contactName }) => name === contactName
  );
  console.log('contact', contact);
  return contact.id._serialized;
};

export default getContactId;
