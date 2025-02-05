<template>
  <div class="auth">
    <div class="auth-container">
      <div class="auth-title">{{ type }}</div>
      <form class="auth-form">
        <label for="username" v-if="type !== 'Log In'">Username: </label>
        <input
          id="username"
          type="text"
          v-model="username"
          v-if="type !== 'Log In'"
        />

        <label for="username">Email: </label>
        <input id="email" type="text" v-model="email" />

        <div class="cb">
          <input
            v-if="type === 'User Info'"
            type="checkbox"
            id="changePassword"
            v-model="changePassword"
          />
          <label v-if="type === 'User Info'" for="changePassword" class="small"
            >Do you want to change your password ?</label
          >
        </div>
        <label
          for="password"
          v-if="(changePassword && type === 'User Info') || type === 'Log In'"
          >Password:
        </label>
        <input
          id="password"
          type="password"
          v-model="password"
          v-if="(changePassword && type === 'User Info') || type === 'Log In'"
        />
      </form>
      <div v-if="type === 'Log In'" class="auth-button" @click="logIn">
        Log In
      </div>
      <div v-if="type === 'User Info'" class="buttons">
        <div
          v-if="type === 'User Info'"
          class="auth-buttons"
          @click="updateUser"
        >
          Update Info
        </div>
        <div
          v-if="type === 'User Info'"
          class="auth-buttons"
          @click="deleteUser"
        >
          Delete Account
        </div>
      </div>
    </div>
  </div>
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
      userId: null,
      userRoleId: null,
      username: null,
      email: null,
      userError: null,
      password: "",
      changePassword: false,
      fetchedUserSuccess: true,
    };
  },
  methods: {
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
    if (this.routeUserId) {
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
.small {
  font-size: 11px;
}
.cb {
  display: flex;
  justify-content: center;
  align-items: center;
}
.buttons {
  display: flex;
  justify-content: space-around;
  width: 100%;
}
.auth {
  width: 80vw;
  height: 70vh;
  display: flex;
  justify-content: center;
  align-items: center;

  &-container {
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    padding: 30px 40px;
    width: 400px;
    border: 2px solid #284350;
    border-radius: 5px;

    .auth-title {
      color: #284350;
      font-weight: 700;
      font-size: 30px;
      margin-bottom: 30px;
    }

    .auth-form {
      display: flex;
      flex-direction: column;
      width: 100%;
      margin-bottom: 30px;

      label {
        color: #546e7a;
        font-weight: 600;
        margin-bottom: 10px;
      }

      input {
        margin-bottom: 20px;
        line-height: 40px;
        padding: 0 5px;
        border-radius: 5px;
        border: 1px solid #546e7a;
        font-size: large;
        color: #284350;

        &:focus {
          outline: none !important;
          border: 2px solid #546e7a;
          border-radius: 5px;
        }
      }
    }

    .auth-button {
      font-weight: 500;
      border: 2px solid #284350;
      border-radius: 50px;
      padding: 10px 30px;
      cursor: pointer;

      &:hover {
        color: whitesmoke;
        background-color: #284350;
      }
    }

    .auth-buttons {
      font-weight: 500;
      font-size: 10px;
      border: 2px solid #284350;
      border-radius: 50px;
      padding: 5px 15px;
      cursor: pointer;

      &:hover {
        color: whitesmoke;
        background-color: #284350;
      }
    }

    .auth-nav {
      margin-top: 30px;
      color: #284350;
      font-weight: 500;

      span {
        text-decoration: underline;
        cursor: pointer;
      }
    }
  }
}
</style>
