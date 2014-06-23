redis-metrics
=============

Lua scripts for analytics with Redis.


What's here?
============

## rradd.lua

Add value(s) to random reservoir(s) using Vitter's R (3).

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

    ./run.sh rradd.lua 2 temperature:reservoir temperature:counter `date +"%N%s"` 5 76.3

#### Caveats

* The seed for the random number generator should change on each invocation of
  the script.
* Changing the fixed size of the reservoir will affect the accuracy of the
  random sample. The effects of this change will decrease as the script is
  repeatedly called.

## rquantile.lua

Calculate a quantile over a reservoir.

**Keys:**  
 *1*: list holding values to be sampled, e.g. `temperature:reservoir`

**Args:**  
 *1*: Quantile to calculate, expressed as a float between 0 and 1, with .5 as
      the median.

**Time Complexity: O(N \* log N)**:  
  *N* is the size of the reservoir.


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

