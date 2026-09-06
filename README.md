# Problem Solving through Search

## Practical No. 3 – Artificial Intelligence and Machine Learning

### Student Details

* **Student Name:** Sanika Laxman Chavan
* **PRN:** 202401070082
* **Branch:** ENTC
* **Division:** A
* **Batch:** A3

## Problem Statement

Develop a search-based problem-solving system using a graph represented as a list of nodes and edge costs. Implement different search strategies and compare their paths and performance.

## Algorithms Implemented

The following algorithms are implemented using SWI-Prolog:

1. Breadth First Search (BFS)
2. Depth First Search (DFS)
3. Best First Search
4. A* Search
5. Hill Climbing
6. N-Queens using Backtracking

## Graph Used

The graph is represented as:

```prolog
graph([
    [a,b,1],
    [a,c,4],
    [b,d,2],
    [b,e,5],
    [c,f,3],
    [d,g,1],
    [e,g,2],
    [f,g,1]
]).
```

Here, the first two values represent the source and destination nodes, and the third value represents the edge cost.

## Heuristic Values

```text
a = 4
b = 3
c = 4
d = 1
e = 2
f = 1
g = 0
```

## Minimum Cost Path

The minimum-cost path from `a` to `g` is:

```text
a → b → d → g
```

Total cost:

```text
4
```

## Software Used

* SWI-Prolog
* GitHub

## How to Run

1. Install SWI-Prolog.
2. Open the Prolog source file.
3. Load the file using:

```prolog
['search_algorithms.pl'].
```

4. Run the required queries.

Example:

```prolog
bfs(a,g,P).
```

```prolog
dfs(a,g,P).
```

```prolog
best_first(a,g,P).
```

```prolog
astar(a,g,P,C).
```

```prolog
hill_climbing(a,g,P).
```

For N-Queens:

```prolog
nqueens(4,Q).
```

## Expected Results

| Algorithm     | Expected Path / Result                   |
| ------------- | ---------------------------------------- |
| BFS           | Shortest path in number of edges         |
| DFS           | Path obtained by depth-first exploration |
| Best First    | `a → b → d → g`                          |
| A*            | `a → b → d → g`, Cost = 4                |
| Hill Climbing | `a → b → d → g`                          |
| N-Queens      | Valid 4-Queens solution                  |

## Conclusion

Different search algorithms use different strategies to find a solution. BFS and DFS are uninformed search methods, while Best First Search and A* use heuristic information. A* considers both path cost and heuristic value. Hill Climbing selects a better neighbouring state. The N-Queens problem was solved using backtracking.
