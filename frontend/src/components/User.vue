<template>
  <div class="User">
    <v-card elevation="4" width="380">
      <v-card-title>{{ type }}</v-card-title>
      <div v-if="userError !== null">
        <div class="no-user-error" v-if="userError">
          <span>This user does not exist.</span>
        </div>
        <div v-else>
          <div v-if="fetchedUserSuccess !== null">
            <div v-if="fetchedUserSuccess">
              <v-form ref="form" v-model="valid" lazy-validation>
                <v-text-field
                  v-if="type !== 'Log In'"
                  v-model="username"
                  label="Username"
                  required
                ></v-text-field>

                <v-text-field
                  v-model="email"
                  :rules="emailRules"
                  label="E-mail"
                  required
                ></v-text-field>

                <v-checkbox
                  v-if="type === 'User Info'"
                  v-model="changePassword"
                  label="Do you want to change your password?"
                  required
                ></v-checkbox>

                <v-text-field
                  :disabled="!changePassword && type === 'User Info'"
                  v-model="password"
                  :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'"
                  :rules="[passwordRules.required, passwordRules.min]"
                  :type="showPassword ? 'text' : 'password'"
                  name="input-10-1"
                  hint="At least 8 characters"
                  counter
                  @click:append="showPassword = !showPassword"
                  label="Password"
                  :required="type === 'User Info' ? false : true"
                ></v-text-field>

                <v-btn
                  v-if="type === 'User Info'"
                  class="mr-4"
                  @click="updateUser"
                >
                  Update Info
                </v-btn>

                <v-btn
                  v-if="type === 'User Info'"
                  color="black"
                  class="mr-4"
                  @click="deleteUser"
                >
                  Delete Account
                </v-btn>

                <v-btn
                  v-if="type === 'Log In'"
                  color="black"
                  class="mr-4"
                  @click="logIn"
                >
                  Log In
                </v-btn>

                <v-btn
                  v-if="type === 'Register'"
                  color="black"
                  class="mr-4"
                  @click="signUp"
                >
                  Register
                </v-btn>
              </v-form>
            </div>

            <div class="no-user-error" v-else>
              <span>This user does not exist.</span>
            </div>
          </div>
          <div class="message" v-if="type === 'Log In'">
            Don't have account ?
            <router-link to="/register">Create one.</router-link>
          </div>
        </div>
      </div>
    </v-card>
  </div>
  <v-snackbar v-model="snackbar" :color="snackbarColor">{{ snackbarText }}</v-snackbar>
</template>

<script lang="ts">
import { defineComponent } from "vue";
import Auth from "@/types/Auth";
import User from "@/types/User";
import { useUserStore } from "@/stores/user";
import router from "@/router";
import Swal from "sweetalert2";
import Send from "@/helpers/sendRequest";
import VueJwtDecode from "vue-jwt-decode";

export default defineComponent({
  name: "UserComponent",
  props: {
    type: {
      readonly: true,
      type: String,
    },
    routeUserId: {
      readonly: true,
      type: Number,
    },
  },
  setup() {
    const userStore = useUserStore();
    return {
      userStore,
    };
  },
  data() {
    return {
      valid: true,
      userId: null,
      userRoleId: null,
      username: null,
      email: null,
      userError: null,
      emailRules: [
        (v) => !!v || "E-mail is required",
        (v) => /.+@.+\..+/.test(v) || "E-mail must be valid",
      ],
      password: "",
      showPassword: false,
      changePassword: false,
      fetchedUserSuccess: true,
      passwordRules: {
        required: (value) => !!value || "Required.",
        min: (v) => v.length >= 8 || "Min 8 characters",
      },
      snackbar: false,
      snackbarText: "",
      snackbarColor: "green",
    };
  },
  methods: {
    signUp() {
      Send.postRequest<Auth>("/auth/signup", {
        username: this.username,
        email: this.email,
        password: this.password,
      })
        .then(() => {
          this.snackbarColor = "green";
          this.snackbar = true;
          this.snackbarText = "You just created your account.";
          router.push("/login");
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    logIn() {
      Send.postRequest<Auth>("/auth/login", {
        email: this.email,
        password: this.password,
      })
        .then((response) => {
          const jwtData = VueJwtDecode.decode(response.data.data.jwt);
          localStorage.setItem("token", JSON.stringify(response.data.data.jwt));
          localStorage.setItem("user", JSON.stringify(jwtData.user));
          this.userStore.connectUser();
          router.push("/");
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    updateUser() {
      const body = {
        username: this.username,
        email: this.email,
      };
      if (this.password !== "") {
        body["password"] = this.password;
      }
      Send.patchRequest<User>(`/users/${this.userId}`, body)
        .then((response) => {
          this.snackbarColor = "green";
          this.snackbar = true;
          this.snackbarText = "You just updated your info.";
          localStorage.setItem("user", JSON.stringify(response.data.data));
        })
        .catch(function (error) {
          console.log(error);
        });
    },
    deleteUser() {
      Swal.fire({
        icon: "error",
        text: "Are you sure to delete " + this.username + " account ?",
        confirmButtonText: "Yes",
        showLoaderOnConfirm: true,
      }).then((r) => {
        if (r.isConfirmed) {
          Send.deleteRequest(`/users/${this.userId}`)
            .then(() => {
              this.snackbarColor = "red";
              this.snackbar = true;
              this.snackbarText = "You just deleted your account.";
              localStorage.removeItem("user");
              localStorage.removeItem("token");
              router.push("/login");
            })
            .catch(function (error) {
              console.log(error);
            });
        }
      });
    },
  },
  async mounted() {
    if (isNaN(this.routeUserId)) {
      this.userId = JSON.parse(localStorage.getItem("user"))?.id;
      this.email = JSON.parse(localStorage.getItem("user"))?.email;
      this.username = JSON.parse(localStorage.getItem("user"))?.username;
      this.userError = false;
    } else {
      try {
        const { data } = await Send.getRequest<User>(
          `/users/${this.routeUserId}`
        );
        this.userId = data.data.id;
        this.email = data.data.email;
        this.userRoleId = data.data.role_id;
        this.username = data.data.username;
        this.userError = false;
      } catch (err) {
        this.userError = true;
      }
    }
  },
});
</script>

<style scoped lang="scss">
.v-card {
  padding: 1rem;
}
.v-card-title {
  font-weight: bold;
  font-size: 25px;
  margin-bottom: 2rem;
}
.v-text-field {
  margin-bottom: 1rem;
}
input {
  background-color: #fcfcfc;
}

.no-user-error {
  background-color: #454955;
  color: #f3eff5;
  padding: 2% 4% 2% 4%;
  font-weight: 600;
  box-shadow: 0 0 7px 0 rgba(0, 0, 0, 0.5);
  border-radius: 8px;
}

a {
  font-size: 15px;
  color: black;
}

.message {
  margin-top: 1rem;
}
</style>
