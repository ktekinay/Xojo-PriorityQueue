#tag Class
Protected Class PriorityQueue_MTC
	#tag Method, Flags = &h0
		Sub Add(priority As Integer, value As Variant)
		  LastIndex = LastIndex + 1
		  if LastIndex = Priorities.Count then
		    //
		    // Expand arrays
		    //
		    var expandTo as integer = min( Priorities.Count * 2, Priorities.Count + 2048 )
		    Priorities.ResizeTo expandTo - 1
		    Values.ResizeTo Priorities.LastIndex
		  end if
		  
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

	#tag Method, Flags = &h0
		Sub Clear()
		  Priorities.ResizeTo 127
		  
		  Values.RemoveAll
		  Values.ResizeTo Priorities.LastIndex
		  
		  LastIndex = -1
		  
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Constructor()
		  Clear
		  
		End Sub
	#tag EndMethod


	#tag ComputedProperty, Flags = &h0
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

	#tag Property, Flags = &h21
		Private Priorities() As Integer
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
			Name="Values()"
			Visible=false
			Group="Behavior"
			InitialValue=""
			Type="Integer"
			EditorType=""
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
