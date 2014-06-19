redis-metrics
=============

Lua scripts for analytics with Redis.


What's here?
============

## rradd.lua

Add value(s) to random reservoir(s) using Vitter's R.

**Keys:**  
 *1*: list holding a random reservoir, e.g. `temperature:reservoir`  
 *2*: counter key maintained by the script, e.g. `temperature:count`  
 
**Args:**  
 *1*: seed for random number generator
 *2*: fixed size for the reservoir, e.g. 1024  
 *3+*: numeric value(s) to be added to all reservoirs.  

**Time Complexity:**  

*O(N * M * L):*  
  *N* is the number of reservoirs
  *M* is the number of values
  *L* is the average reservoir size.

#### Examples

./run.sh rradd.lua 2 temperature:reservoir temperature:counter `date +"%N%s"` 5 76.3

#### Caveats

* The seed for the random number generator should change on each invocation of
  the script.
* Changing the fixed size of the reservoir will affect the accuracy of the
  random sample. The effects of this change will decrease as the script is
  repeatedly called.


Notes
=====

* Time complexities here estimate the complexity of the algorithms implemented
  making (perhaps naive) assumptions about the implementations of libraries
  called. They have not been tested and are here to document the expectations
  of the (also perhaps naive) author.
