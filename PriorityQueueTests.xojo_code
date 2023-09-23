#tag Class
Protected Class PriorityQueueTests
Inherits TestGroup
	#tag CompatibilityFlags = (TargetConsole and (Target32Bit or Target64Bit)) or  (TargetWeb and (Target32Bit or Target64Bit)) or  (TargetDesktop and (Target32Bit or Target64Bit)) or  (TargetIOS and (Target64Bit)) or  (TargetAndroid and (Target64Bit))
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
		    Assert.AreEqual "", spy.Validate.StringValue
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ClearTest()
		  var pq as new PriorityQueue_MTC
		  
		  for i as integer = 1 to 1000
		    pq.Add i, i
		  next
		  
		  var spy as new ObjectSpy( pq )
		  var parr() as double = spy.Priorities
		  var pCount as integer = parr.Count
		  var varr() as object = spy.Values
		  var vCount as integer = varr.Count
		  
		  Assert.AreEqual pCount, vCount
		  Assert.AreEqual 1000, pq.Count
		  
		  pq.Clear
		  
		  parr = spy.Priorities
		  var pCount2 as integer = parr.Count
		  varr = spy.Values
		  vCount = varr.Count
		  
		  Assert.AreEqual pCount2, vCount
		  Assert.IsTrue pCount2 < pCount
		  Assert.AreEqual 0, pq.Count
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ConstructorTest()
		  var pq as new PriorityQueue_MTC
		  var spy as new ObjectSpy( pq )
		  
		  var priorities() as double = spy.Priorities
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

	#tag Method, Flags = &h0
		Sub DuplicatePriorityTest()
		  var pq as new PriorityQueue_MTC
		  pq.Add 1, 1
		  pq.Add 1, 2
		  pq.Add 2, 3
		  pq.Add 3, 4
		  pq.Add 1, 5
		  pq.Add 2, 6
		  pq.Add 3, 7
		  
		  Assert.AreEqual 1.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 1.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 1.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 2.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 2.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 3.0, pq.PeekPriority
		  
		  call pq.Pop
		  
		  Assert.AreEqual 3.0, pq.PeekPriority
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MassiveAddTest()
		  var arrCount as integer = 100000
		  var sourceArr() as double
		  for i as integer = 1 to arrCount
		    sourceArr.Add ( ( i - 1 ) mod 1000 ) + 1
		  next
		  
		  sourceArr.Shuffle
		  
		  var pq as new PriorityQueue_MTC
		  
		  var sw as new Stopwatch_MTC
		  sw.Start
		  
		  for i as integer = 0 to sourceArr.LastIndex
		    pq.Add sourceArr( i ), i
		    sw.Lap
		  next
		  
		  sw.Stop
		  Assert.Message "Average add: " + sw.AverageLapMicroseconds.ToString( "#,##0.00" ) + " µs"
		  
		  sourceArr.Sort
		  
		  var spy as new ObjectSpy( pq )
		  
		  var cycle as integer
		  
		  sw.Reset
		  
		  for each expected as double in sourceArr
		    if pq.PeekPriority <> expected then 
		      Assert.AreEqual expected, pq.PeekPriority
		    end if
		    
		    sw.Start
		    call pq.Pop
		    sw.Stop
		    
		    cycle = cycle + 1
		    if cycle = 1000 then
		      Assert.AreEqual "", spy.Validate.StringValue
		      cycle = 0
		    end if
		  next
		  
		  Assert.AreEqual 0, pq.Count
		  
		  var avg as double = sw.ElapsedMicroseconds / sourceArr.Count
		  Assert.Message "Average pop: " + avg.ToString( "#,##0.00" ) + " µs"
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub MaxToMinTest()
		  var arrCount as integer = 100
		  var sourceArr() as double
		  for i as integer = 1 to arrCount
		    sourceArr.Add i
		  next
		  
		  for reps as integer = 1 to 10
		    sourceArr.Shuffle
		    
		    var pq as new PriorityQueue_MTC( false )
		    
		    for each p as integer in sourceArr
		      pq.Add p, p
		    next
		    
		    Assert.AreEqual arrCount, pq.Count
		    
		    var spy as new ObjectSpy( pq )
		    Assert.AreEqual "", spy.Validate.StringValue
		    
		    sourceArr.Sort
		    
		    for i as integer = sourceArr.LastIndex downto 0
		      Assert.AreEqual "", spy.Validate.StringValue, "Failed at " + i.ToString
		      if Assert.Failed then
		        exit
		      end if
		      
		      var expected as double = sourceArr( i )
		      var actualPriority as double = pq.PeekPriority
		      Assert.AreEqual expected, actualPriority
		      
		      var actualValue as double = pq.Pop
		      Assert.AreEqual expected, actualValue
		    next
		  next
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PeekTest()
		  var pq as new PriorityQueue_MTC
		  pq.Add 10, 10000
		  pq.Add 20, 20000
		  pq.Add 5, 5000
		  pq.Add 1, 1000
		  pq.Add 2, 2000
		  
		  Assert.AreEqual 1.0, pq.PeekPriority
		  Assert.AreEqual 1000, pq.PeekValue.IntegerValue
		  
		  call pq.Pop
		  
		  Assert.AreEqual 2.0, pq.PeekPriority
		  Assert.AreEqual 2000, pq.PeekValue.IntegerValue
		  
		  call pq.Pop
		  
		  Assert.AreEqual 5.0, pq.PeekPriority
		  Assert.AreEqual 5000, pq.PeekValue.IntegerValue
		  
		  call pq.Pop
		  
		  Assert.AreEqual 10.0, pq.PeekPriority
		  Assert.AreEqual 10000, pq.PeekValue.IntegerValue
		  
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub PopTest()
		  var arrCount as integer = 100
		  var sourceArr() as integer
		  for i as integer = 1 to arrCount
		    sourceArr.Add i
		  next
		  
		  for reps as integer = 1 to 10
		    sourceArr.Shuffle
		    
		    var pq as new PriorityQueue_MTC
		    for each p as integer in sourceArr
		      pq.Add p, p
		    next
		    
		    Assert.AreEqual arrCount, pq.Count
		    
		    var spy as new ObjectSpy( pq )
		    
		    for expected as integer = 1 to arrCount
		      var value as integer = pq.Pop
		      Assert.AreEqual expected, value
		      Assert.AreEqual "", spy.Validate.StringValue
		    next
		  next
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub ReferenceTest()
		  var d as new Dictionary
		  var wr as new WeakRef( d )
		  
		  var pq as new PriorityQueue_MTC
		  pq.Add 2, d
		  pq.Add 1, new Dictionary
		  
		  d = nil
		  Assert.IsNotNil wr.Value
		  
		  call pq.Pop
		  Assert.IsNotNil wr.Value
		  
		  call pq.Pop
		  Assert.IsNil wr.Value
		End Sub
	#tag EndMethod


End Class
#tag EndClass
