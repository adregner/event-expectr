Event Expectr
=============

This is a wraper around the Expectr gem (https://github.com/cwuest/expectr).  It simply allows you to define a list of patterns and code blocks which will all be checked for a match against an instance of Expectr.  When one of them matches, the code block is executed.  This makes automating some processes easier, however it breaks with the original expect (ala TCL) workflow.

Example
-------

```ruby
irb(main):001:0> require 'event-expectr'
=> true
irb(main):002:0> e = EventExpectr.new "ssh root@server.example.com", :flush_buffer => false
=> #<EventExpectr:0x007ff2eb09abd8 @timeout=30, @expectr=#<Expectr:0x007ff2eb09abb0 @buffer="", @discard="", @timeout=0.01, @flush_buffer=false, @buffer_size=8192, @constrain=false, @force_match=false, @out_mutex=#<Mutex:0x007ff2eb09aa70>, @out_update=false, @interact=false, @stdout=#<File:/dev/ttys004>, @stdin=#<File:/dev/ttys004>, @pid=8828>, @patterns={}>
irb(main):003:0> e.expect("Are you sure you want to continue connecting (yes/no)?") {|match| e.expectr.puts "yes"}
=> #<Proc:0x007ff2eb0201d0@(irb):5>
irb(main):004:0> e.expect(/Password: $/) {|match| e.expectr.puts "pa55w0rd"}
=> #<Proc:0x007ff2eb19f920@(irb):6>
irb(main):005:0> e.expect(/^root@([a-z0-9]+).*# /i) {|match| puts "Login to #{match[1]} successful"}
=> #<Proc:0x007ff2eb17d3c0@(irb):7>
irb(main):005:0> e.run!, :blocking => true
```

Each time a pattern matches, it is removed from the internal hash of patterns it checks in the EventExpectr#run! method.  When there are no patterns left to check, run! will return true.  It will also return with a false value if the timeout is reached before all the matches are made.

You can set the EventExpectr#running value to false at any time when the run! method is running to cause it to bail out immediatly.  So, if you have many patterns and code blocks, and when one of them matches you want to stop all further matching, just do something like this:

```ruby
e.expect /^root@([a-z0-9]+).*# /i do |match|
  puts "Login to #{match[1]} successful"
  e.running = false
end
```
