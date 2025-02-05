import axios from "axios";
import { AxiosResponse } from "axios";
import { AxiosSuccess, AxiosError } from "@/types/Axios";

const Axios = axios.create({
	baseURL: process.env.VUE_APP_TIME_MANAGER_API,
});

Axios.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem("token");
    // const session = localStorage.getItem("user");
    if (token) {
      const jwt = token.substring(1, token.length - 1);
      config.headers.Authorization = "Bearer " + jwt;
    }
    // if (session) {
    //   config.headers.Session = JSON.stringify(session);
    // }
    return config;
  },
  (error) => {
    // Do something with request error
    return Promise.reject(error);
  }
);

class Send {
	public static async getRequest<T>(url: string): Promise<AxiosResponse<AxiosSuccess<T>>> {
		return await Axios.get(url);
	}
	public static async postRequest<T>(url: string, body?: object): Promise<AxiosResponse<AxiosSuccess<T>>> {
		return await Axios.post(url, body);
	}
	public static async deleteRequest<T>(url: string): Promise<AxiosResponse<AxiosSuccess<T>>> {
		return await Axios.delete(url);
	}
	public static async patchRequest<T>(url: string, body?: object): Promise<AxiosResponse<AxiosSuccess<T>>> {
		return await Axios.patch(url, body);
	}
}

export default Send;
