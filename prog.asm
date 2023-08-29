vall 1101			// program 1 start (1)
valh 0001
mova v				// store 29 in a
vall 1011	
valh 0011	
movb v				// store 59 in b
load a d			// .load_routine
	decr a			// d= {00000, b11, b10, b9}
	load a c		// c= {b8, b7, b6, b5, b4, b3, b2, b1}
	decr a		 
movm c				// .parity_8
	movn d			// {n,m} holding data
	lslc n 4		// n= {0, b11, b10, b9, b8, b7, b6, b5}
	movm m			// m= 8'b00000000;
	lslc n 1		// n= {b11, b10, b9, b8, b7, b6, b5, 0}
	movx m			// x= m
	mthr parx		// r= ^x
	jizr r	010		// if odd parity else jump by 0100 4 (pc = 22)
		valh 0000	
		vall 1000
		flip v		// n^00000001
	movd n			// d= n= {b11, b10, b9, b8, b7, b6, b5, p8}
movm c				// .parity_4 m= {b8, b7, b6, b5, b4, b3, b2, b1}
	movn n			// n= 00000000
	lslc m 4		// m= {b4, b3, b2, b1, 0, 0, 0, 0}
	valh 0001
	vall 0000		// v= 00010000
	movx v			// x= 00010000
	movy m			// y= {b4, b3, b2, b1, 0000}
	mthr amp		// r= {000, b1, 0000}
	valh 1110		// v= 11100000
	movx v			// x= 11100000
	mths amp		// s= {b4, b3, b2, 00000}
	----movc s			// c= {b4, b3, b2, 00000}
	valh 0000
	vall 0001		// v= 00000001
	movx r			// x= {000, b1, 0000}
	movy v			// y= 00000111
	mthr rol		// r= {0000, b1, 000}
	movx r			// x= r
	movy c			// y= {b4, b3, b2, 00000}
	mthr lor		// r= {b4, b3, b2, 0, b1, 000}
	movm r			// m= r
	movy d			// y= {b11, b10, b9, b8, b7, b6, b5, p8}
	vall 0000
	valh 1111		// v= {11110000}
	movx v			// x= v
	mthr amp		// r= {b11, b10, b9, b8, 0000}
	movx r			// x= r
	mthr parx		// r= ^{b11, b10, b9, b8}
	movy c			// y= {b4, b3, b2, 00000}
	mths pary		// s= ^{b4, b3, b2}
	movx r
	movy s
	mthr eor		// r= ^{b11, b10, b9, b8, b4, b3, b2}
	jizr r	010		// if odd parity else jump by 0100 4 (pc= 60)
		valh 0000	
		vall 0100
		flip v		// m^0001000
	movc m			// c= m= {b4, b3, b2, p4, b1, 000}
movx c				// .parity_2 x= c
	valh = 1100
	vall = 1100
	movy v			// y= 11001100
	mthr amp		// r= x&y = {b4, b3, 00, b1, 000}
	movx d			// x= {b11, b10, b9, b8, b7, b6, b5, p8}
	mths amp		// s= {b11, b10, 00, b7, b6, 00}
	movx r
	movy s
	mthr parx		// r= ^{b4, b3, b1}
	mths pary		// s= ^{b11, b10, b7, b6}
	movx r
	movy s
	mthr eor		// r= ^{b11, b10, b7, b6, b4, b3, b1}
	jizr r	010		// if odd parity else jump by 0100 4 (pc = 79)
		valh 0000	
		vall 0011
		flip v		// m^00000100
	movc m			// c= m= {b4, b3, b2, p4, b1, p2, 00}
movx c				// .parity_1
	valh 1010
	vall 1010
	movy v			// y= 10101010
	mthr amp		// r= {b4, 0, b2, 0, b1, 000}
	movx d			// x= {b11, b10, b9, b8, b7, b6, b5, p8}
	mths amp		// s= {b11, 0, b9, 0, b7, 0, b5, 0}
	movx r
	movy s
	mthr parx		
	mths pary
	movx r
	movy s
	mthr eor		// r= ^{b11, b9, b7, b5, b4, b2, b1}
	jizr r	010		// if odd parity else jump by 0100 4 (pc= 98)
		valh 0000	
		vall 0001
		flip v		// m^00000010
	movc m			// c= m= {b4, b3, b2, p4, b1, p2, p1, 0}
movx c				// .parity_0
	movy d
	mthr parx
	mths pary
	movx r
	movy s
	mthr eor		// r= {b11, b10, b9, b8, b7, b6, b5, p8, b4, b3, b2, p4, b1, p2, p1}
	jizr r	010		// if odd parity else jump by 0100 4 (pc = 110)
		valh 0000	
		vall 0000
		flip v		// m^00000001
	movc m			// c= m= {b4, b3, b2, p4, b1, p2, p1, p0}
stor b n			// .stor_routine
	decr b
	stor b m
	decr b
vall 0111			// .prog1_complete
	ltlh 0000
	movz v
	bnzr a			// branch if a != 0
movl v		// v= 00000000
	func strl		// start_address = 0000000000
	vall 0001		// v= 00000001
	func strh		// start_address = 0100000000
	func done		// done = 1;


































































































































// program 2 start (256)
vall 1101			
valh 0001
mova v				// store 29 in a
vall 1011	
valh 0011	
movb v				// store 59 in b
load b d			// .load_routine
	decr b			// d= {b11, b10, b9, b8, b7, b6, b5, p8}
	load b c		// c= {b4, b3, b2, p4, b1, p2, p1, p0}
	decr b		 
movm m				// .parity_0
	movn n			// m= n = 0
	movx c			// x= c
	movy d			// y= d
	mthr parx		// r= ^{b4, b3, b2, p4, b1, p2, p1, p0}
	mths pary		// s= ^{b11, b10, b9, b8, b7, b6, b5, p8} (parity 8)
	movx r
	movy s
	mthr eor		// r= p0 = ^{b11, b10, b9, b8, b7, b6, b5, p8, b4, b3, b2, p4, b1, p2, p1, p0}
	movm s			// m= p8
	lslc m 3		// m= {0000, p8, 000}
	movn r			// n= p0
vall 0000			// .parity_4
	valh 1111
	movy v			// y= 11110000
	movx c			// x= {b4, b3, b2, p4, b1, p2, p1, p0}
	mthr amp		// r= {b4, b3, b2, p4, 0000}
	movx d			// x= {b11, b10, b9, b8, b7, b6, b5, p8}
	mths amp		// s= {b11, b10, b9, b8, 0000}
	movx r			// calculate parity with masked bits
	movy s
	mthr parx
	mths pary
	movx r			
	movy s
	mthr eor		// r= p4 = ^{b11, b10, b9, b8, b4, b3, b2, p4}
	jizr r 0001		// if odd parity, else jump to 293
		seth 0010	// m = {0000, p8, p4, 0, 0}
vall 1100			// .parity_2
	valh 1100
	movy v			// y= 11001100
	movx c			// x= {b4, b3, b2, p4, b1, p2, p1, p0}
	mthr amp		// r= {b4, b3, 00, b1, p2, 00}
	movx d			// x= {b11, b10, b9, b8, b7, b6, b5, p8}
	mths amp		// s= {b11, b10, 00, b7, b6, 00}
	movx r			// calculate parity with masked bits
	movy s
	mthr parx
	mths pary
	movx r			
	movy s
	mthr eor		// r= p2 = ^{b11, b10, b7, b6, b4, b3, b1, p2}
	jizr r 0001		// if odd parity, else jump to 309
		seth 0001	// m= {0000, p8, p4, p2, 0}
vall 1010			// .parity_1
	valh 1010
	movy v			// y= 10101010
	movx c			// x= {b4, b3, b2, p4, b1, p2, p1, p0}
	mthr amp		// r= {b4, 0, b2, 0, b1, 0, p1, 0}
	movx d			// x= {b11, b10, b9, b8, b7, b6, b5, p8}
	mths amp		// s= {b11, 0, b9, 0, b7, 0, b5, 0}
	movx r			// calculate parity with masked bits
	movy s
	mthr parx
	mths pary
	movx r			
	movy s
	mthr eor		// r= p1= ^{b11, b10, b7, b6, b4, b3, b1, p2}
	jizr r 001		// if odd parity, else jump to 325
		seth 0000	// m= {0000, p8, p4, p2, p1}
movi m				// .error_correction i= m
	movj n			// j= {0000000, b0}
	movm c
	movn d			// {n,m}= {b11, b10, b9, b8, b7, b6, b5, p8, b4, b3, b2, p4, b1, p2, p1, p0}
	movy y
	movx n
	mthr lor		// r= {0000000, b0}
	mths amp		// s= 00000000
	jizr r 011-		// if b0= 1, else pc= 339
		flip i		// flip bit in {n,m} in position i[3:0]= {p8, p4, p2, p1}
		valh 0100	// (one error)
		vall 0000	// v= 01000000
		jizr s 101	// jump to 347
	movk k			// no op padding
	movx i
	mthr lor		// r = {0000, p8, p4, p2, p1}
	jizr r 011		// if b0= 0 && (p8|p4|p2|p1), else jump to 347
		valh 1000	// (two errors)
		vall 0000	// v= 10000000
		jizr s 001	// jump to 346
	movl v			// (no errors) v= 00000000
	movk v
	movk v 			// k= {F1, F0, 000000}
	movc m			// store data in {d,c}
	movd n
valh 1110			// .decode data
	vall 1000
	movy v			// y= {11101000} 
	movx m			// x= {b4, b3, b2, p4, b1, p2, p1, p0}
	mthr amp		// r= {b4, b3, b2, 0, b1, 000}
	movm r			// m= r
	movn n			// n= 00000000
	lsrc m 011		// m= {000, b4, b3, b2, 0, b1}
	lsrc n 001		// n= {b1, 0000000}
	lsrc m 010		// m= {00000, b4, b3, b2}
	lslc m 101		// m= {b4, b3, b2, b1, 0000}
	movx d			// x= {}
	valh 0000
	vall 0111
	movy v 			// y= 00000111
	mthr rol		// r= {p8, b11, b10, b9, b8, b7, b6, b5}
	movx r			// x= r
	valh 0111
	vall 1111
	movy v			// y= 01111111
	mthr amp		// r= {0, b11, b10, b9, b8, b7, b6, b5}
	movn r			// n= r
	lsrc m 100		// m= {b8, b7, b6, b5, b4, b3, b2, b1}
	movc m			// c stores lower decoded data
	movm m 			// m= 00000000
	lsrc n 100		// n= {00000, b11, b10, b9}
	movx n			// x= n
	movy k			// y= {F1, F0, 000000}
	mthr lor		// r= {F1, F0, 000, b11, b10, b9}
	movd r			// d stores upper decoded data
stor a d			// .store_routine
	decr a
	stor a c
	decr a
valh 0000			// check completion
	vall 0101
	movz v
	bnzr a			// if a!=0, then continue from 261 (0100000101)
movl v				// v= 00000000
	func strl		// start_address = 0000000000
	vall 0010		// v= 00000010
	func strh		// start_address = 1000000000 (512)
	func done		// done = 1;






















































































































// program 3 (512) 1000000000
vall 0000				// .initialization
	valh 0010
	movc c				// c= 00000000 (occurences in byte)
	movd d				// d= 00000000 (occurences across bytes)
	movb v				// b= 00100000 (32)
	movi v				// i= 00100000 (32)
	mova a				// a= 00000000 (0)
	load a m			// m= 01234567
	incr a
	decr i
movj j					// j= 00000000 (occured in byte) .setup_next_byte
	load b x			// x= vwxyz000
	load a n			// n= 89abcdef .load_next_byte
	incr a				
	decr i
mthr eql5				// r= (x[7:4] == m[7:4]) .check_pos0
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {1234567, 8} .check_pos1
	lslc n 001			// n= {9abcdef, 1}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {234567, 89} 
	lslc n 001			// n= {abcdef, 12}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {34567, 89a} .check_pos3
	lslc n 001			// n= {bcdef, 123}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {4567, 89ab} .check_pos4
	lslc n 001			// n= {cdef, 1234}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 001			// if equal, else jump +2
		incr d			
lslc m 001				// m= {567, 89abc} .check_pos5
	lslc n 001			// n= {def, 12345}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 001			// if equal, else jump +2
		incr d			
lslc m 001				// m= {67, 89abcd} .check_pos6
	lslc n 001			// n= {ef, 123456}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 001			// if equal, else jump +2
		incr d			
lslc m 001				// m= {7, 89abcde} .check_pos7
	lslc n 001			// n= {f, 1234567}
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 001			// if equal, else jump +2
		incr d			
	lslc m 001			// m= {89abcdef}
movx j					// x= j (0 if no in-byte occurrences, >0 if atleast one)
	movy y				// y= 0
	mthr lor			// r= x= k
	jizr r 001
		incr k
vall 1010				// .check_completion
	valh 0000
	movz v				// z=00001010 (10)
	bnzr i				// if i = 0, else jump back to 1000001010 (522)
movj j					// j= 00000000 .last_byte0 -------------------------
	movn n				// n= 00000000
	load b x			// x= vwxyz000
	mthr eql5			// r= (x[7:4] == m[7:4]) 
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {1234567, 0} .last_byte1
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {234567, 00} .last_byte2
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
lslc m 001				// m= {34567, 000} .last_byte3
	mthr eql5			// r= (x[7:4] == m[7:4])
	jizr r 010			// if equal, else jump +4
		incr c			
		incr j
		incr j
movx j					// x= j (0 if no in-byte occurrences, >0 if atleast one)
	movy y				// y= 0
	mthr lor			// r= x= k
	jizr r 001
		incr k
valh 0010				// .store_complete
	vall 0001
	movb v				// b= 00100001 (33)
	stor b c			// mem[33] = occurrences in byte
	movm k
	incr b
	stor b m			// mem[34] = bytes with occurrences
	incr b
	movx c
	movy d
	mthr add			// r= (c + d) = (occurences in byte) + (occurences across bytes)
	stor b r			// mem[35] = total occurrences
	func done
