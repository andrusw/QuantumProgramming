namespace Quantum.Bell
{
    open Microsoft.Quantum.Primitive;
    open Microsoft.Quantum.Canon;
    
	//return Unit  aka void in C#
    operation Set (desired: Result, q1 : Qubit) : Unit 
	{
        let current = M(q1);//Measure qubit

		//not in the state we want
		if(desired != current)
		{
			X(q1);//flip the state
		}
    }

	//loop for [count] 
	//returns three value tuple
	operation BellTest(count: Int, initial: Result) : (Int,Int,Int)
	{
		mutable numOnes = 0; //declare chanageable variable
		mutable agree = 0;//keep track of every time measurement match

		//using - allocate an array of qubits 
		//and release at the end of the block
		using (qubits = Qubit[2])
		{
			for(test in 1..count)//similar to python
			{
				Set(initial, qubits[0]);
				Set(Zero, qubits[1]);

				//superpostion test
				//X(qubits[0]); //test just a basic flip
				H(qubits[0]); //test Hadamard gate - flip it only half way
				CNOT(qubits[0],qubits[1]);
				
				let res = M(qubits[0]);//Measure result

				//Count the number of ones we saw:
				if(res == One)
				{
					set numOnes = numOnes + 1;
				}
			}

			//reset to a known state of zero
			Set(Zero, qubits[0]);
			Set(Zero, qubits[1]);
		}

		//return number of times we saw a |0> and number of times we saw a |1>
		return(count-numOnes, numOnes, agree);
	}
}
