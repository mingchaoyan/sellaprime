# sellaprime

##build
```sh
$ git clone https://github.com/mingchaoyan/sellaprime.git
...
$ cd sellaprime
$ rebar prepare-deps
...
$ rebar compile
...
```

##release
```sh
$ mkdir rel
$ cd rel
$ rebar create-node nodeid=sp
...
```
edit reltool.config as follow
```erlang
%% -*- mode: erlang -*-
%% ex: ft=erlang
{sys, [
       {lib_dirs, []},
       {erts, [{mod_cond, derived}, {app_file, strip}]},
       {app_file, strip},
       {rel, "sp", "1.0.0",
        [
         kernel,
         stdlib,
         sasl,
         goldrush,
         lager,
         sp
        ]},
       {rel, "start_clean", "",
        [
         kernel,
         stdlib
        ]},
       {boot_rel, "sp"},
       {profile, embedded},
       {incl_cond, derived},
       {excl_archive_filters, [".*"]}, %% Do not archive built libs
       {excl_sys_filters, ["^bin/(?!start_clean.boot)",
                           "^erts.*/bin/(dialyzer|typer)",
                           "^erts.*/(doc|info|include|lib|man|src)"]},
       {excl_app_filters, ["\.gitignore"]},
       {app, goldrush, [{mod_cond, app}, {incl_cond, include}, {lib_dir, "../deps/goldrush"}]},
       {app, lager, [{mod_cond, app}, {incl_cond, include}, {lib_dir, "../deps/lager"}]},
       {app, sp, [{mod_cond, app}, {incl_cond, include}, {lib_dir, ".."}]}
      ]}.

{target_dir, "sp"}.

{overlay, [
           {mkdir, "log/sasl"},
           {copy, "files/erl", "\{\{erts_vsn\}\}/bin/erl"},
           {copy, "files/nodetool", "releases/\{\{rel_vsn\}\}/nodetool"},
           {copy, "sp/bin/start_clean.boot",
                  "\{\{erts_vsn\}\}/bin/start_clean.boot"},
           {copy, "files/sp", "bin/sp"},
           {copy, "files/sp.cmd", "bin/sp.cmd"},
           {copy, "files/start_erl.cmd", "bin/start_erl.cmd"},
           {copy, "files/sys.config", "releases/\{\{rel_vsn\}\}/sys.config"},
           {copy, "files/vm.args", "releases/\{\{rel_vsn\}\}/vm.args"}
          ]}.
```
then
```sh
$ rebar generate
...
```

##start
```sh
$ cd sp
$ ./bin/sp start
$ ./bin/sp getpid
...
$ ./bin/sp attach
```

##new_prime
```erlang
1>prime_server:new_prime(1).
3
```
##stop
```sh
$./bin/sp stop
```
