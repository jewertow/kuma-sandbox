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
backend_1   | Headers:
backend_1   | Accept */*
backend_1   | Content-Length 0
backend_1   | User-Agent curl/7.76.1
backend_1   | X-Request-Id 2a94163a-9722-48b9-8898-c2e5e61660c5
backend_1   | X-Forwarded-Proto http
backend_1   | X-Forwarded-Client-Cert By=spiffe://default/backend;Hash=b4eef49492b79af1fb12e60e6d157ae8002dfbb6f026403dbeeb633943ab7459;URI=spiffe://default/frontend
backend_1   | X-Kuma-Forwarded-Client-Cert spiffe://default/frontend
backend_1   | X-Kuma-Forwarded-Client-Service frontend
```

