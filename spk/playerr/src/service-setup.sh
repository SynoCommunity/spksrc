PYTHON_DIR="/usr/local/python3"
# Usamos un comando genérico de servicio o arrancamos el docker directamente si no hay wrapper disponible
# Para este caso simple, definimos las variables que usará el instalador
DOCKER_IMAGE="maikboarder/playerr:latest"
DOCKER_CONTAINER="playerr"
SERVICE_COMMAND="docker run -d --name ${DOCKER_CONTAINER} --restart unless-stopped -p 2727:8080 -v /volume1/docker/playerr/config:/app/config -v /volume1/downloads:/media ${DOCKER_IMAGE}"
SVC_BACKGROUND=y
SVC_WRITE_PID=y
