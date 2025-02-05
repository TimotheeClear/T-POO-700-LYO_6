import User from "./User";

interface Auth {
  jwt: string;
  user: User;
}

export default Auth;
