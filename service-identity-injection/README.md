## Test environment for testing service identity injection

Run the following command to setup environment based on docker containers:
```bash
./setup-env.sh
```

When the environment starts up, execute a request from the "frontend" to the "backend" service:
```bash
docker exec docker_frontend_1 curl -v localhost:5000/echo
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
backend_1   | X-Kuma-Forwarded-Client-Zone eu-west-1
```

And then execute a request from the "backend" to the "frontend":
```bash
docker exec docker_backend_1 curl -v localhost:5000/echo
```

You should see logs as before:
```
frontend_1   | Headers:
frontend_1   | Accept */*
frontend_1   | Content-Length 0
frontend_1   | User-Agent curl/7.76.1
frontend_1   | X-Request-Id 2a94163a-9722-48b9-8898-c2e5e61660c5
frontend_1   | X-Forwarded-Proto http
frontend_1   | X-Forwarded-Client-Cert By=spiffe://default/frontend;Hash=5e2a88638abba79a4b1c295fe484769c4e1f4b4385340fb87fbd5027f75e9e54;URI=spiffe://default/backend
frontend_1   | X-Kuma-Forwarded-Client-Cert spiffe://default/backend
frontend_1   | X-Kuma-Forwarded-Client-Service backend
frontend_1   | X-Kuma-Forwarded-Client-Zone us-east-1
```
