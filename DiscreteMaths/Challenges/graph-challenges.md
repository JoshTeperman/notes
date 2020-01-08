<!-- https://gist.github.com/DeepNeuralAI/000db38867eefedc7f909e2c520e557f#file-4_challenges-md -->

# Challenges - Graphs

[Play with this for a few mins](https://visualgo.net/en/sssp?slide=1)

#### 1. Draw out the graph for the edge-list:

    (S, 5, A), (S, 2, B), (A, 4, C), (B, 8, A), (C, 6, D), (A, 2, D), (C, 3, F), (D, 1, F)


#### 2. Find the shortest path for the graph in Question 1.


8 = (S, A, D, F)

#### 3. Draw out the graph for the following matrix (Optional):

![image](https://github.gatech.edu/storage/user/27745/files/82db1f80-7b41-11e9-9c16-50696a6115ce)

4. The below is a matrix representation of nodes in a graph.


  |  | A | B | C | D | E
  | ------------- | ------------- |------------- |------------- | ------------- |  ------------- |
  | A  | 0 | 2 | 2 | 0 | 10 |
  | B  | 2 | 0 | 3 | 0 | 0  |
  | C  | 2 | 3 | 0 | 1 | 0  |
  | D  | 0 | 1 | 0 | 0 | 8  |
  | E  | 0 | 0 | 0 | 0 | 4  |

#### Find the shortest path from A to E. 

E<sup>A</sup> = 10

_To do this, draw out the graph. Perhaps try Dijkstra's Algorithm?_