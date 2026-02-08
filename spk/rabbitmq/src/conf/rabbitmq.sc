[rabbitmq]
title="RabbitMQ"
desc="RabbitMQ AMQP"
port_forward="yes"
dst.ports="5671,5672/tcp"

[rabbitmq_empd]
title="RabbitMQ empd"
desc="RabbitMQ epmd discovery service"
port_forward="yes"
dst.ports="4369/tcp"

[rabbitmq_management]
title="RabbitMQ management"
desc="RabbitMQ management plugin"
port_forward="yes"
dst.ports="15672/tcp"

[rabbitmq_stomp]
title="RabbitMQ STOMP"
desc="RabbitMQ STOMP plugin"
port_forward="yes"
dst.ports="61613,61614/tcp"

[rabbitmq_mqtt]
title="RabbitMQ MQTT"
desc="RabbitMQ MQTT plugin"
port_forward="yes"
dst.ports="1883,8883/tcp"

[rabbitmq_web_stomp]
title="RabbitMQ Web STOMP"
desc="RabbitMQ Web STOMP plugin"
port_forward="yes"
dst.ports="15674/tcp"

[rabbitmq_web_mqtt]
title="RabbitMQ Web MQTT"
desc="RabbitMQ Web MQTT plugin"
port_forward="yes"
dst.ports="15675/tcp"

[rabbitmq_prometheus]
title="RabbitMQ Prometheus"
desc="RabbitMQ Prometheus plugin"
port_forward="yes"
dst.ports="15692/tcp"
