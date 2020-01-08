https://gist.github.com/DeepNeuralAI/000db38867eefedc7f909e2c520e557f
https://medium.com/basecs/a-gentle-introduction-to-graph-theory-77969829ead8

1. Intro to Graphs
https://www.youtube.com/watch?v=o3_AAYVGfjQ

Defining a graph: 
G = (V, E)
... where V = vertices (set of nodes), and E = edges (links)

UNORDERED GRAPH:
![Unordered Graph](https://camo.githubusercontent.com/8db67d3abd0f9d5e3a7111dadc00b45437709895/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a676f5438736970516244496f6f6756364b635f334b412e6a706567)

ORDERED GRAPH:
![Ordered Graph](https://camo.githubusercontent.com/966260b950979b0038645ea2d78c20f9779fc0a5/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a5468443562664c55794578343973355339714b4b6f772e6a706567)

Graph: nodes connected together

Tree: only connected to two other nodes (looks like a tree), and can only flow in one direction, from parent down to child
Binary tree: left child is always less than the parent

Graphs used when looking for routers when connecting to the internet
Used for maps - cities are nodes

All trees are graphs, but not all graphs are trees

DiGraph (Directed Graph) : directions indicated by arrows
... Can be represented using
- edge list [AB, BA, AC, CD] (each of the 'edges')
- matrix 
  A B C D
A O |
B | O
C O O 
D O O

... can store adiditional information on the edges, eg AC3 A-3-C

Unidrected Graph : no arrows, means you can travel in any directions

Shortest Path: Sum of the adges ABD (AB + BD)
.. Can calculate using Dijkstra's Algorithm

AB = AB or ACB


1a. Algorithms

Breadth-first: number of steps 'can we get to End in 3 steps?'
This kind of algorithm is called breadth-first search.\
Useful if edge distance is uniform.\
Typically finds the __shortest__ path

Dijkstra's Algorithm: Find the __fastest__ path.\
STEPS:\
![](https://camo.githubusercontent.com/8b457a0df91b79b730373d3ce0129c4af0ad7627/68747470733a2f2f6769746875622e6761746563682e6564752f73746f726167652f757365722f32373734352f66696c65732f31323763643030302d376233612d313165392d386538352d323038626339353939383462)
A) Find the cheapest node. This is the node you can get to in the least amount of time. A = 6, B = 2, Finish = ?\
B) Continuing from the recent shortest path node (B), check whether there is a cheaper path to the neighbors of this node.
If so, update their costs.\
![find cheaper path](https://camo.githubusercontent.com/4b3146736367abe02d4e5427a98f0af3f28b0817/68747470733a2f2f6769746875622e6761746563682e6564752f73746f726167652f757365722f32373734352f66696c65732f61343339306430302d376233622d313165392d386566622d626139666366623663346431)
A (BA) = 5, Finish = 7s
C) Repeat until you've done this for every node\
From node A: BAFinish = 6
D) Calculate the final path

Challenges
![](https://camo.githubusercontent.com/06084646ab7ddcd686ff491135e75d4689fbde2c/68747470733a2f2f6769746875622e6761746563682e6564752f73746f726167652f757365722f32373734352f66696c65732f62393136613030302d376233642d313165392d383832332d643966353033313364313461)


2.  The Seven Bridges of Konigsberg
https://www.youtube.com/watch?v=W18FDEA1jRQ

Odd num of bridges: have to start or end at that location
Even num: can start anywhere
Two odd islands: can start on one and end on the other

Therefore if all bridges are odd, cannot traverse all bridges.
Therefore if there are If there an even number of odd bridges, you can start on an odd bridge and be able to traverse all bridges by ending on the second odd bridge.
Therefore of there are an even number of odd bridges it will be impossible. 
Therefore if all islands are even it's no problem. 
It's impossible to have only one odd bridge island. 


3. How the bridge problem changed mathematics
https://www.youtube.com/watch?v=nZwSo4vfw6c

Geometry of position (Graph Theory)
Nodes with edges (lines) between them
Beginning and end of the 'walk' may be odd edge numbers

A ulirian path that visits each edge only once is only possible in two scenarios. 
1) When there are ony two nodes of odd degree (start and end point)
2) When all nodes are even (ulirian circuit), meaning start and end point are the same

4. Dijkstra's Algorithm
https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm
https://www.youtube.com/watch?v=GazC3A4OQTE

Path finding algorithms:
- Finding shortest path / maps
- Routing / finding best path to route packets

Dijkstra's implementation with road / pathfinding
- map of nodes representing intersectinos
- edges are roads
- each edge has a 'difficulty', could be calculated from type of road (highway etc), length of road, time

Arguments:
graph (data)
S = start, distance = 0
List of Nodes, with distance = infinity
E = end, distance starts as infinity (because not calculated )

1) order paths from S by smallest distance, SA1, SC3, SD3, SB5
2) keep track of where you've come from (S for step one)
3) put S in 'finished'
4) move on to next (current) shortest path, which is A, and map paths from that node
5) ignoring S, map paths from A: AX, AY, AZ
6) calculate the paths to X, Y, Z, still starting from S, and log total distance 'd' (which was infinity for new nodes)
7) if X, Y, Z are new nodes, add them to the list (path will be from A, where you've just come from) with 'd'
8) else if SAX, SAY, SAZ are shorter than SX, SY, SZ, update the path and the distance (eg: path is now the latest SAX, and d is now 5 instead of 7). But only track the most recent node (AX, not SAX)
9) A is done, can change to 'finished'
10) Should have updated priority queue (shortest distance from SAx, where x is the node with distance 'd')
11) Map remaining S paths, and add those to the queue (eg SBx, SBy) then return to next priority (x)
12) When encountering nodes that we've already done, we can discount them (we already know the shortest path), if current path is longer than known shortest path we don't make a change. 
13) when reaching E (end), calculate total route  > go back through route and add up all paths together

... for larger graphs, you would prioritize edges (motorways etc)
... no intelligence about direction built in- faster doesn't necessarily mean right direction

Implementation: 

https://hackernoon.com/how-to-implement-dijkstras-algorithm-in-javascript-abdfd1702d04
https://repl.it/@stella_sighs/dijkstramedium


const graph = {
  start: {A: 5, B: 2},
  A: {C: 4, D: 2},
  B: {A: 8, D: 7},
  C: {D: 6, finish: 3},
  D: {finish: 1},
  finish: {}
};

const findLowestCostNode = (costs, processed) => {
  const knownNodes = Object.keys(costs)
  
  const lowestCostNode = knownNodes.reduce((lowest, node) => {
      if (lowest === null && !processed.includes(node)) {
        lowest = node;
      }
      if (costs[node] < costs[lowest] && !processed.includes(node)) {
        lowest = node;
      }
      return lowest;
  }, null);

  return lowestCostNode
};

// function that returns the minimum cost and path to reach Finish
const dijkstra = (graph) => {
  console.log('Graph: ')
  console.log(graph)

  // track lowest cost to reach each node
  const trackedCosts = Object.assign({finish: Infinity}, graph.start);
  console.log('Initial `costs`: ')
  console.log(trackedCosts)

  // track paths
  const trackedParents = {finish: null};
  for (let child in graph.start) {
    trackedParents[child] = 'start';
  }
  console.log('Initial `parents`: ')
  console.log(trackedParents)

  // track nodes that have already been processed
  const processedNodes = [];

  // Set initial node. Pick lowest cost node.
  let node = findLowestCostNode(trackedCosts, processedNodes);
  console.log('Initial `node`: ', node)

  console.log('while loop starts: ')
  while (node) {
    console.log(`***** 'currentNode': ${node} *****`)
    let costToReachNode = trackedCosts[node];
    let childrenOfNode = graph[node];
  
    for (let child in childrenOfNode) {
      let costFromNodetoChild = childrenOfNode[child]
      let costToChild = costToReachNode + costFromNodetoChild;
  
      if (!trackedCosts[child] || trackedCosts[child] > costToChild) {
        trackedCosts[child] = costToChild;
        trackedParents[child] = node;
      }

      console.log('`trackedCosts`', trackedCosts)
      console.log('`trackedParents`', trackedParents)
      console.log('----------------')
    }
  
    processedNodes.push(node);

    node = findLowestCostNode(trackedCosts, processedNodes);
  }
  console.log('while loop ends: ')

  let optimalPath = ['finish'];
  let parent = trackedParents.finish;
  while (parent) {
    optimalPath.push(parent);
    parent = trackedParents[parent];
  }
  optimalPath.reverse();

  const results = {
    distance: trackedCosts.finish,
    path: optimalPath
  };

  return results;
};

console.log('dijkstra', dijkstra(graph));


![internet](https://camo.githubusercontent.com/e6f205034ee0090a36e28f748fe1c831569cd4d5/687474703a2f2f70692e6d6174682e636f726e656c6c2e6564752f7e6d65632f57696e746572323030392f52616c75636152656d75732f4c656374757265352f696d61672e6a7067)

Facebook, Undirected Graph
![Facebook](https://camo.githubusercontent.com/4b3fbf66678190a7387d056eaa5a0257becb7deb/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a7178765a582d5952427352726d4d356550764e4151412e6a706567)

Twitter, Directed Graph
![Twitter](https://camo.githubusercontent.com/c61da98afbf7140213e7e471de63021370cb987c/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a75724a547266576e38615a64686239412d48585a56672e6a706567)


|  | A | B | C | D 
| ------------- | ------------- |------------- |------------- | ------------- |
| A  | 0 | 1 | 2 | 0 |
| B  | 3 | 4 | 0 | 0 |
| C  | 0 | 0 | 0 | 5 |
| D  | 0 | 0 | 0 | 0 |

(node_from, weight, node_to)\
node A to node B: (A, 1, B)

therefore E, for edges equals:

node A to node B: (A, 1, B)\
node B to node A: (B, 3, A)\
node A to node C: (A, 2, C)\
node C to node D: (C, 5, D)


EULER's SOLUTION
<!-- https://gist.github.com/DeepNeuralAI/000db38867eefedc7f909e2c520e557f#file-5_euler-md -->

https://medium.com/basecs/k%C3%B6nigsberg-seven-small-bridges-one-giant-graph-problem-2275d1670a12

![](https://camo.githubusercontent.com/d6e2af8bed02425d284429d428171ebe440bbe5b/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a393445783337622d6f4679563844635f4f6b70326e512e6a706567)
![](https://camo.githubusercontent.com/bc1f2eadbb3f4910fad5924b79374df8be12e4f0/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313230302f312a484c366e7339444a30304c727830367a666577736d512e6a706567)

Cambridge University:

Euler proved it couldn’t be done because he worked out that to have an odd vertex you would have to begin or end the trip at that vertex. (Think about it). Since there can only be one beginning and one end, there can only be two odd vertices if you’re going to be able to trace over each arc only once. Since the bridge problem has 4 odd vertices, it just isn’t possible to do!

![](https://camo.githubusercontent.com/a1c8f4bd6561a538fc314ab2c71813684b7b99c7/68747470733a2f2f63646e2d696d616765732d312e6d656469756d2e636f6d2f6d61782f313630302f312a4f69733673494d4f6e6565722d42562d5569694f48412e6a706567)

In Graph 1, there are two vertices (A and E) with an odd degree, and so it is possible to traverse each edge once. However, we won’t end up at the same vertex that we started on.


In Graph 2, all of the vertices have an even degree, so we could not just traverse each edge only once, but we could end up at the same place that we started!


Graph 3 though — sadly, there’s just no possible way to make this work on a Eulerian level. This graph has the exact same issue as the Königsberg problem: there are four vertices that are odd, and since we know we can never have more than two odd degree vertices, we can be sure that this graph isn’t Eulerian, in the slightest!