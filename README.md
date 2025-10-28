# Full Cycle - Go tiny image

Este repositório contém um binário Go mínimo que, ao executar a imagem Docker, imprime:

    Full Cycle Rocks!!

Como funciona
- `main.go` contém um programa Go que só imprime a mensagem e sai.
- `Dockerfile` é multistage: usa a imagem oficial `golang:1.20` para compilar e instala `upx` para comprimir o binário; a imagem final é baseada em `scratch`, gerando uma imagem muito pequena (meta: <2MB).

A imagem está publicada no DockerHub no link: https://hub.docker.com/repository/docker/tgroque/fullcycle/general

Build, testar e publicar (PowerShell)

```powershell
# build localmente (substitua <seu-user> pelo seu usuário Docker Hub)
docker build -t tgroque/fullcycle:latest .

# verificar tamanho localmente
docker images --format "{{.Repository}}: {{.Size}}" | findstr fullcycle

# rodar
docker run --rm tgroque/fullcycle:latest

```
