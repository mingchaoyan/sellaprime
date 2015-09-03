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
$ cd rel
$ rebar generate
...
```

##start
```sh
$ cd sp
$ ./bin/sp start
$ ./bin/sp attach
```

```erlang
1>application:start(sellaprime).
2>prime_server:new_prime(1).
3
```
##stop
```sh
$./bin/sp stop
```
