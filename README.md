# Debug iRODS Build

# build for your user

```
docker build -t debug_my_irods --build-arg={login=`whoami`,uid=`id -u`,gid=`id -g`} .
```
