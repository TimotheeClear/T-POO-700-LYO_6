interface AxiosSuccess<T> {
  data: T;
}

interface AxiosError<T> {
  errors: T;
}

export { AxiosSuccess, AxiosError };
