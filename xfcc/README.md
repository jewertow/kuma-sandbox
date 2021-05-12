## Test environment for PR [1941](https://github.com/kumahq/kuma/pull/1941)

Run the following command to setup environment based on docker containers:
```bash
./setup-env.sh
```

When the environment starts up, get into the container with service "frontend":
```bash
docker exec -it docker_frontend_1 /bin/sh
```
and then execute a request to the "backend" service:
```bash
curl -v localhost:5000/echo
```

You should see the following logs:
```
backend_1                 | Headers:
backend_1                 | X-Request-Id 895284e8-a1e1-473e-9072-36bef42d992d
backend_1                 | X-Forwarded-Client-Cert By=spiffe://default/backend;Hash=cba99ba9f01582e32b6dfa42ae88439171c562b7ecc47e501020d7e62c0abe75;URI=spiffe://default/frontend
backend_1                 | Content-Length 0
backend_1                 | User-Agent curl/7.76.1
backend_1                 | Accept */*
backend_1                 | X-Forwarded-Proto http
```

