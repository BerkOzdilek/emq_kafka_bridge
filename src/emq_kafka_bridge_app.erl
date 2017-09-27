-module(emq_kafka_bridge_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
    {ok, Sup} = emq_kafka_bridge_sup:start_link(),
    emq_kafka_bridge_config:register(),
    emq_kafka_bridge:load(application:get_all_env()),
    {ok, Sup}.

stop(_State) ->
	emq_kafka_bridge_config:unregister(),
    emq_kafka_bridge:unload().
    