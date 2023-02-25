#tag Class
Protected Class PriorityQueueTests
Inherits TestGroup
	#tag Method, Flags = &h0
		Sub AddTest()
		  var arrCount as integer = 100
		  var sourceArr() as integer
		  for i as integer = 1 to arrCount
		    sourceArr.Add i
		  next
		  
		  for reps as integer = 1 to 10
		    sourceArr.Shuffle
		    
		    var pq as new PriorityQueue_MTC
		    for each p as integer in sourceArr
		      pq.Add p, nil
		    next
		    
		    Assert.AreEqual arrCount, pq.Count
		    
		    var spy as new ObjectSpy( pq )
		    var priorities() as integer = spy.Priorities
		    
		    for i as integer = 1 to arrCount - 1
		      var parentIndex as integer = ( i - 1 ) \ 2
		      Assert.IsTrue priorities( parentIndex ) <= priorities( i )
		    next
		    
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructorTest()
		  var pq as new PriorityQueue_MTC
		  var spy as new ObjectSpy( pq )
		  
		  var priorities() as integer = spy.Priorities
		  var priorityCount as integer = priorities.Count
		  
		  var values() as variant = spy.Values
		  var valueCount as integer = values.Count
		  
		  var lastIndex as integer = spy.LastIndex
		  
		  Assert.AreNotEqual 0, priorityCount
		  Assert.AreEqual priorityCount, valueCount
		  
		  Assert.AreEqual -1, lastIndex
		  Assert.AreEqual 0, pq.Count
		  
		End Sub
	#tag EndMethod


End Class
#tag EndClass
