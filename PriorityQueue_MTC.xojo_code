#tag Class
Protected Class PriorityQueue_MTC
	#tag Method, Flags = &h0, Description = 41646420612076616C756520746F2074686520717565756520776974682074686520676976656E205072696F726974792E
		Sub Add(priority As Integer, value As Variant)
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  LastIndex = LastIndex + 1
		  if LastIndex = Priorities.Count then
		    //
		    // Expand arrays
		    //
		    var expandTo as integer = min( Priorities.Count * 2, Priorities.Count + 2048 )
		    Priorities.ResizeTo expandTo - 1
		    Values.ResizeTo Priorities.LastIndex
		  end if
		  
		  //
		  // Adjust
		  //
		  priority = ( PriorityBase - priority ) * PriorityMultiplier
		  
		  Priorities( LastIndex ) = priority
		  Values( LastIndex ) = value
		  
		  //
		  // Reposition as needed
		  //
		  var currentIndex as integer = LastIndex
		  
		  while currentIndex <> 0
		    var parentIndex as integer = ( currentIndex - 1 ) \ 2
		    var parentPriority as integer = Priorities( parentIndex )
		    
		    if priority >= parentPriority then
		      //
		      // We're done
		      //
		      exit
		    end if
		    
		    //
		    // Swap
		    //
		    var parentValue as variant = Values( parentIndex )
		    
		    Priorities( currentIndex ) = parentPriority
		    Values( currentIndex ) = parentValue
		    
		    Priorities( parentIndex ) = priority
		    Values( parentIndex ) = value
		    
		    currentIndex = parentIndex
		  wend
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 526573657473207468652051756575652E
		Sub Clear()
		  Priorities.ResizeTo 127
		  
		  Values.RemoveAll
		  Values.ResizeTo Priorities.LastIndex
		  
		  LastIndex = -1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 5768656E206D696E546F4D61782020697320547275652C2077696C6C2072657475726E2061205072696F726974792076616C7565206F662031206265666F726520612076616C7565206F66203130302E205768656E2046616C73652C2076616C7565203130302077696C6C2062652072657475726E6564206265666F72652076616C756520312E
		Sub Constructor(minToMax As Boolean = True)
		  if minToMax then
		    PriorityBase = 0
		    PriorityMultiplier = -1
		  else
		    #if Target64Bit
		      PriorityBase = &h7FFFFFFFFFFFFFFF
		    #else
		      PriorityBase = &h7FFFFFFF
		    #endif
		    PriorityMultiplier = 1
		  end if
		  
		  Clear
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0, Description = 52656D6F766520616E642072657475726E207468652056616C75652061742074686520746F70206F66207468652051756575652E
		Function Pop() As Variant
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if LastIndex = -1 then
		    raise new OutOfBoundsException
		  end if
		  
		  var returnValue as variant = Values( 0 )
		  
		  if LastIndex = 0 then
		    Values( 0 ) = nil
		    LastIndex = -1
		    return returnValue
		  end if
		  
		  //
		  // Shuffle the tree
		  //
		  var priority as integer = Priorities( LastIndex )
		  var value as variant = Values( LastIndex )
		  Values( LastIndex ) = nil // Remove any references
		  LastIndex = LastIndex - 1
		  
		  var index as integer = 0
		  Priorities( index ) = priority
		  Values( index ) = value
		  
		  do
		    var leftChildIndex as integer = index * 2 + 1
		    if leftChildIndex > LastIndex then
		      //
		      // We're done
		      //
		      exit
		    end if
		    
		    var rightChildIndex as integer = leftChildIndex + 1
		    
		    var leftPriority as integer = Priorities( leftChildIndex )
		    var rightPriority as integer = if( rightChildIndex <= LastIndex, Priorities( rightChildIndex ), priority )
		    
		    if priority <= leftPriority and priority <= rightPriority then
		      //
		      // We're done
		      //
		      exit
		    end if
		    
		    var swapIndex as integer = if( rightPriority < leftPriority, rightChildIndex, leftChildIndex )
		    
		    Priorities( index ) = Priorities( swapIndex )
		    Values( index ) = Values( swapIndex )
		    
		    Priorities( swapIndex ) = priority
		    Values( swapIndex ) = value
		    
		    index = swapIndex
		  loop
		  
		  return returnValue
		  
		End Function
	#tag EndMethod

	#tag Method, Flags = &h21
		Private Function Validate() As String
		  #if not DebugBuild
		    #pragma BackgroundTasks false
		    #pragma BoundsChecking false
		    #pragma NilObjectChecking false
		    #pragma StackOverflowChecking false
		  #endif
		  
		  if Priorities.Count = 0 then
		    return "Priorities array is not dimensioned"
		  end if
		  
		  if Values.Count <> Priorities.Count then
		    return "Values array is mis-dimensioned"
		  end if
		  
		  if LastIndex < -1 then
		    return "LastIndex < -1"
		  end if
		  
		  if LastIndex > Priorities.LastIndex then
		    return "LastIndex > Priorities.LastIndex"
		  end if
		  
		  for i as integer = 1 to LastIndex
		    var parentIndex as integer = ( i - 1 ) \ 2
		    var thisPriority as integer = Priorities( i )
		    var parentPriority as integer = Priorities( parentIndex )
		    
		    if thisPriority < parentPriority then
		      return "Improper entry at index " + i.ToString + ": " + _
		      "Priority is " + thisPriority.ToString + " but parent priority is " + parentPriority.ToString
		    end if
		  next
		  
		End Function
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0, Description = 546865206E756D626572206F66206974656D7320696E207468652051756575652E
		#tag Getter
			Get
			  return LastIndex + 1
			  
			End Get
		#tag EndGetter
		Count As Integer
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private LastIndex As Integer = -1
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0, Description = 546865205072696F72697479206F662056616C75652061742074686520746F70206F66207468652071756575652E
		#tag Getter
			Get
			  if LastIndex = -1 then
			    return -1
			  end if
			  
			  var priority as integer = Priorities( 0 )
			  
			  //
			  // Adjust
			  //
			  priority = ( PriorityBase - priority ) * PriorityMultiplier
			  
			  return priority
			  
			End Get
		#tag EndGetter
		PeekPriority As Integer
	#tag EndComputedProperty

	#tag ComputedProperty, Flags = &h0, Description = 5468652056616C75652061742074686520746F70206F66207468652051756575652E
		#tag Getter
			Get
			  return if( LastIndex = -1, nil, Values( 0 ) )
			  
			End Get
		#tag EndGetter
		PeekValue As Variant
	#tag EndComputedProperty

	#tag Property, Flags = &h21
		Private Priorities() As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PriorityBase As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PriorityMultiplier As Integer
	#tag EndProperty

	#tag Property, Flags = &h21
		Private Values() As Variant
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			InitialValue="-2147483648"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			InitialValue=""
			Type="String"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			InitialValue="0"
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="Count"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
		#tag ViewProperty
			Name="PeekPriority"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
