# TIME MANAGER

## Project setup
### Backend
* Add a file `backend/.env` and add the following lines :
```
export POSTGRES_USER="youruser"
export POSTGRES_PASSWORD="yourpassword"
export POSTGRES_HOST="yourhost"
export POSTGRES_DB="time_manager"
```
* Install dependencies with 
```
mix deps.get
```
* Create and migrate your database with 
```
mix ecto.setup
```
* In `backend/` run
```
./start_server.sh
```

### Frontend
* Add a file `frontend/.env` and add the following line :
```
VUE_APP_TIME_MANAGER_API=http://localhost:4000/api
```
* In `frontend/` run
```
npm install
npm run serve
```

### Mobile
* Add a file `mobile/time-manager/.env` and add the following line :
```
VUE_APP_TIME_MANAGER_API=http://localhost:4000/api
```
* In `mobile/time-manager` run
```
npm run build
cordova run android
```
