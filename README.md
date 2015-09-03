# sellaprime
rebar prepare-deps
rebar co
erl -pa ebin -pa deps/*/ebin -s lager
application:start(sellaprime).
prime_server:new_prime(11).
