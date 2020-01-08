Time Complexity:
- linear time O(n) 
-- T = an + b 
- constant time O(1)
- quadrant time O(n**2)
-- T = cn**2 + dn + e
- logarithmic time = O(logn) / log2n = k
-- [Log Time](.https://hackernoon.com/what-does-the-time-complexity-o-log-n-actually-mean-45f94bb5bfbf)

A few concrete examples. Just say I'm in front of a class of students and one of them has my pen. Here are some ways to find the pen and what the O order is.

O(n2 ): I question a student and ask them, "Does Jeff have the pen? No? Does Bob have the pen?" And so on, naming each student. If I don't get the answer from the first student, I move on to the next one. In the worst case I need to ask n^2 questions - questioning each student about each other student.

O(n): I ask each student if they have the pen. If not, I move on to the next one. In the worst case I need to ask n questions.

O(log n): I divide the class in two, then ask: "Is it on the left side, or the right side of the classroom?" Then I take that group and divide it into two and ask again, and so on. In the worst case I need to ask log n questions.

I might need to do the O(n2 ) search if only one student knows on which student the pen is hidden. I'd use the O(n) if one student had the pen and only they knew it. I'd use the O(log n) search if all the students knew, but would only tell me if I guessed the right name.