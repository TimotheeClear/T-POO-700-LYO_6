type Email = `$[a-z0-9.-_]+@[a-z0-9.-].[a-z]`;

interface User {
  id: number;
  username: string;
  role_id: number;
  email: Email;
}

export default User;
