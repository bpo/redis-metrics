redis-metrics
=============

Lua scripts for analytics with Redis.

Loading and Running
===================

To load any of these scripts and test it against a local Redis server, use
`run.sh`:

**usage**: `./run.sh script numkeys [key ...] [arg ...]`

*script* is the path of a file containing a lua script  
*numkeys* is the number of keys modified by that script

Each key is accessible in the lua script using the KEYS global variable.  
Each arg is accessible in the lua script using the ARGV global variable.

**example:** $ ./run.sh hello.lua 0

To build something integrating these scripts into a real environment, see the
docs on [`EVAL`](http://redis.io/commands/eval) and
[`EVALSHA`](http://redis.io/commands/evalsha), and check out the way your client
library supports loading and managing Lua scripts.


What's here?
============

## naiveadd.lua

Add value(s) to an unbounded reservoir.

**Keys:**  
 *1*: list holding an unbounded reservoir.

**Args:**  
 *1+*: numeric value(s) to be added to the reservoir.

**Time Complexity: O(N)**  
 *N* is the number of values added with this operation.

## fradd.lua

Add value(s) to a simple sliding-window reservoir.

**Keys:**  
 *1*: list holding a simple sliding reservoir, e.g. `temperature:reservoir`

**Args:**  
 *1*: fixed size for the reservoir, e.g. 1024  
 *2+*: numeric value(s) to be added to the reservoir.

**Time Complexity: O(N)**
  *N* is the number of values added with this operation

## rradd.lua

Add value(s) to a random reservoir using Vitter's R (3).

**Keys:**  
 *1*: list holding a random reservoir, e.g. `temperature:reservoir`  
 *2*: counter key maintained by the script, e.g. `temperature:count`  
 
**Args:**  
 *1*: seed for random number generator  
 *2*: fixed size for the reservoir, e.g. 1024  
 *3+*: numeric value(s) to be added to the reservoir.  

**Time Complexity: O(N \* M)**   
  *N* is the number of values added with this operation  
  *M* is the fixed size of the reservoir

#### Examples

Add '76.3' to a random reservoir of temperatures.

    ./run.sh rradd.lua 2 temperature:reservoir temperature:counter `date +"%N%s"` 1024 76.3

#### Caveats

* The seed for the random number generator should change on each invocation of
  the script. In the example above I've seeded with the nanosecond date from GNU
  `date`. In a real environment you might do this with bytes from /dev/urandom.
* Changing the fixed size of the reservoir will affect the accuracy of the
  random sample. The effects of this change will decrease as the script is
  repeatedly called.

## rquantile.lua

Calculate a quantile over an unsorted reservoir.

**Keys:**  
 *1*: list holding values to be sampled, e.g. `temperature:reservoir`

**Args:**  
 *1*: Quantile to calculate, expressed as a float between 0 and 1, with .5 as
      the median.

**Time Complexity: O(N \* log N)**:  
  *N* is the size of the reservoir.

#### Examples

Calcluating the median temperature:

    ./run.sh rquantile.lua 1 temperature:reservoir 0.5

Notes
=====

* Time complexities here estimate the complexity of the algorithms implemented
  making (perhaps naive) assumptions about the implementations of libraries
  called. They have not been tested and are here to document the expectations
  of the (also perhaps naive) author.


Citations
=========

3. Vitter, Jeffrey S. ["Random sampling with a reservoir."][vitter] ACM Transactions on
   Mathematical Software (TOMS) 11.1 (1985): 37-57.

[vitter]: http://www.mathcs.emory.edu/~cheung/papers/StreamDB/RandomSampling/1985-Vitter-Random-sampling-with-reservior.pdf

