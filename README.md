# Docker image for agents connected over SSH

fork from https://github.com/jenkinsci/docker-ssh-agent

## build

```bash
docker build -t ssh:1.0.0 -f Dockerfile .
```

## run
```bash
docker run --rm -it -e "AGENT_SSH_PUBKEY=<public key>" -p 2022:22 ssh:1.0.0
ssh debian@localhost -p 2022
```
