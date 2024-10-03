import { whatsappClient } from '../constants';

const getContactId = async (name: string) => {
  const contacts = await whatsappClient.getContacts();
  const [contact] = contacts.filter(
    ({ name: contactName }) => name === contactName
  );
  return contact.id._serialized;
};

export default getContactId;
