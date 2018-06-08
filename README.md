# FM2018
Project of Formal Methods

## Delivery
The pdf file containing the first part of the project and all the TRIO axioms can be found in DeliveryFolder/TRIO.pdf

## ZOT

To run zot, from the base directory FM2018:

```
./run.sh zot test.lisp
python zot/clean-history.py
```

`test.lisp` will produce a sample history that will show the behaviour of the
robot for 20 time instants. This should be enough to show all the six possible
actions that are implemented in the model.

The grid has been shrunk considerably, to have only 15 areas.

|    |    |    | BA |
| 9  | 10 | 11 | 12 |
| 5  |  6 | 7  | 8  |
| 1  |  2 | 3  | 4  |
| TB | CB |    |    |

where `BA` is the bin area, `TB` is the tombstone and `CB` is the conveyor belt.
The robot has only two parts, the cart and the arm, and therefore can at most occupy
two areas at a time.
