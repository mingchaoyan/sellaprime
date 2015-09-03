%% ---
%%  Excerpted from "Programming Erlang, Second Edition",
%%  published by The Pragmatic Bookshelf.
%%  Copyrights apply to this code. It may not be used to create training material, 
%%  courses, books, articles, and the like. Contact us if you are in doubt.
%%  We make no guarantees that this code is fit for any purpose. 
%%  Visit http://www.pragmaticprogrammer.com/titles/jaerlang2 for more book information.
%%---
-module(sellaprime_sup).
-behaviour(supervisor).		% see erl -man supervisor
-export([start/0, start_in_shell_for_testing/0, start_link/1, init/1]).

start() ->
    spawn(fun() ->
		  supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = [])
	  end).
start_in_shell_for_testing() ->
    {ok, Pid} = supervisor:start_link({local,?MODULE}, ?MODULE, _Arg = []),
    unlink(Pid).
start_link(Args) ->
    supervisor:start_link({local,?MODULE}, ?MODULE, Args).
init([]) ->
    %% Install my personal error handler
     gen_event:swap_handler(alarm_handler, 
                                  {alarm_handler, swap},
				   {my_alarm_handler, xyz}),
    {ok, {{one_for_one, 3, 10},
	  [{tag1, 
	    {area_server, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [area_server]},
	   {tag2, 
	    {prime_server, start_link, []},
	    permanent, 
	    10000, 
	    worker, 
	    [prime_server]},
       {tag3, 
        {prime_tester_server, start_link, []},
        permanent, 
        10000, 
        worker,
        [prime_server]
       }
	  ]}}.



%%
%% - MaxR should be low enough that escalation is not needlessly delayed.
%%   Remember that if you have multiple levels of supervisors, MaxR will
%%   multiply; you might want to set MaxR=0 for most higher supervisors.
%% - MaxT should be low enough that unrelated restarts aren't counted as
%%   looping restart (think: how long does it take for the effects of a
%%   problem to "heal"?); if MaxT is too low, there may not be time enough
%%   for MaxR restarts.
%%
%% In general, think about what should happen if a certain process restars.
%% Some processes may be designed as "kernel processes", such that the only
%% reasonable course of action, should they crash, is to terminate the node.
%%
%% I've chosen three restarts in 10 seconds.
%%
