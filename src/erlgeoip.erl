-module(erlgeoip).

-export([
    init/0,
    lookup/1,
    normalize_city/1
]).

-on_load(init/0).

-spec init() -> ok.
init() ->
    PrivDir = case code:priv_dir(?MODULE) of
                  {error, _} ->
                      EbinDir = filename:dirname(code:which(?MODULE)),
                      AppPath = filename:dirname(EbinDir),
                      filename:join(AppPath, "priv");
                  Dir -> Dir
              end,
    SoName = filename:join(PrivDir, "geoip_nif"),
    case catch erlang:load_nif(SoName,[]) of
        ok -> ok;
        LoadError -> error_logger:error_msg("erlgeoip: error loading NIF (~p): ~p",
                                            [SoName, LoadError])
    end.

lookup(_Ip) ->
    {error, geoip_nif_not_loaded}.

normalize_city(_City) ->
    {error, geoip_nif_not_loaded}.
