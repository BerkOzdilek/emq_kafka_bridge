-module (emq_kafka_bridge_config).

-include_lib("emq_kafka_bridge.hrl").

-export ([register/0, unregister/0]).


%%--------------------------------------------------------------------
%% API
%%--------------------------------------------------------------------
register() ->
    clique_config:load_schema([code:priv_dir(?APP)], ?APP),
    register_formatter(),
    register_config().

unregister() ->
    unregister_formatter(),
    unregister_config(),
    clique_config:unload_schema(?APP).


%%--------------------------------------------------------------------
%% Get ENV Register formatter
%%--------------------------------------------------------------------
register_formatter() ->
    [clique:register_formatter(cuttlefish_variable:tokenize(Key), 
     fun formatter_callback/2) || Key <- keys()].

formatter_callback([_, _, "server"], Params) ->
    lists:concat([proplists:get_value(host, Params), ":", proplists:get_value(port, Params)]).

%%--------------------------------------------------------------------
%% UnRegister formatter
%%--------------------------------------------------------------------
unregister_formatter() ->
    [clique:unregister_formatter(cuttlefish_variable:tokenize(Key)) || Key <- keys()].


%%--------------------------------------------------------------------
%% Set ENV Register Config
%%--------------------------------------------------------------------
register_config() ->
    Keys = keys(),
    [clique:register_config(Key , fun config_callback/2) || Key <- Keys],
    clique:register_config_whitelist(Keys, ?APP).

config_callback([_, _, "server"], Value0) ->
    {Host, Port} = parse_servers(Value0),
    {ok, Env} = application:get_env(?APP, server),
    Env1 = lists:keyreplace(host, 1, Env, {host, Host}),
    Env2 = lists:keyreplace(port, 1, Env1, {port, Port}),
    application:set_env(?APP, server, Env2),
    " successfully\n".

%%--------------------------------------------------------------------
%% UnRegister config
%%--------------------------------------------------------------------
unregister_config() ->
    Keys = keys(),
    [clique:unregister_config(Key) || Key <- Keys],
    clique:unregister_config_whitelist(Keys, ?APP).


%%--------------------------------------------------------------------
%% Internal Functions
%%--------------------------------------------------------------------
keys() ->
    ["bridge.kafka.server"].

parse_servers(Value) ->
    case string:tokens(Value, ":") of
        [Domain]       -> {Domain, 3306};
        [Domain, Port] -> {Domain, list_to_integer(Port)}
    end.














