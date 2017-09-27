PROJECT = emq_kafka_bridge
PROJECT_DESCRIPTION = Kafka bridge
PROJECT_VERSION = 1.0

DEPS = ekaf clique
dep_ekaf = git https://github.com/helpshift/ekaf master
dep_clique = git https://github.com/emqtt/clique

BUILD_DEPS = emqttd cuttlefish
dep_emqttd = git https://github.com/emqtt/emqttd master
dep_cuttlefish = git https://github.com/emqtt/cuttlefish

NO_AUTOPATCH = cuttlefish


COVER = true

include erlang.mk

app:: rebar.config

app.config::
	deps/cuttlefish/cuttlefish -l info -e etc/ -c etc/emq_kafka_bridge.conf -i priv/emq_kafka_bridge.schema -d data
