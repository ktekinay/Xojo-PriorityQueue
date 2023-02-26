# Xojo-PriorityQueue

A Priority Queue class for Xojo.

## Description

This project implements a heap-based Priority Queue. You can add arbitrary values with arbitrary priorities, then retrieve those items according to their priority, either min-to-max or max-to-min.

## Installation

Open the included `PriorityQueue Harness` project and copy `PriorityQueue_MTC` into your project.

## Usage

Create a new min-to-max Queue, e.g., a value with a priority of 1 will be returned before one with a priority of 10:

```
var pq as new PriorityQueue_MTC
```

Or a max-to-min Queue, e.g., a value with a priority of 10 will be returned before one with a priority of 1:

```
var pq as new PriorityQueue_MTC( false )
```

Add items to the Queue:

```
pq.Add 1, "First priority"
pq.Add 10, "Last priority"
pq.Add 5, "Middle priority"
```

Retrieve items from the Queue:

```
// min-to-max
var value as Variant

value = pq.Pop // "First priority"
value = pq.Pop // "Middle priority"
value = pq.Pop // "Last priority"
```

You can look ahead to get information about the value at the top of the queue:

```
var priority as integer = pq.PeekPriority // 1
var value as variant = pq.PeekValue // "First priority"

call pq.Pop // Removes the top item

priority = pq.PeekPriority // 5
value = pq.PeekValue // "Middle priority"
```

Other things you can do:

```
var count as integer = pq.Count // Number of items in the Queue

pq.Clear // Reset the queue
```

## Who Did This

This project was created by and is maintained by Kem Tekinay (ktekinay@mactechnologies dot com).

## Comments and Contributions

All contributions to this project will be gratefully considered. Fork this repo to your own, then submit your changes via a Pull Request.

All comments are also welcome.

## Release Notes

#### 1.0 (Feb. 26, 2023)

- Initial release.
