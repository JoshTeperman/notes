1. HTML Truth Tables

NOT ¬
AND ∧
OR ∨
XOR ⊕
IMPLIES ⇒
LOGICAL EQUIVALENT ⇔

<table>
  <tr>
    <th>A</th>
    <th>B</th>
    <th>A ¬ B</th>
    <th>A ∧ B</th>
    <th>A ∨ B</th>
    <th>A ⊕ B</th>
  </tr>
  <tr>
    <td>True</td>
    <td>True</td>
    <td>False</td>
    <td>True</td>
    <td>True</td>
    <td>False</td>
  </tr>
  <tr>
    <td>True</td>
    <td>False</td>
    <td>True</td>
    <td>False</td>
    <td>True</td>
    <td>True</td>
  </tr>
  <tr>
    <td>False</td>
    <td>True</td>
    <td>True</td>
    <td>False</td>
    <td>True</td>
    <td>True</td>
  </tr>
  <tr>
    <td>False</td>
    <td>False</td>
    <td>False</td>
    <td>True</td>
    <td>False</td>
    <td>False</td>
  </tr>
</table>

2. p is "I like Maths"

q is "I am going to spend at least 6 hours a week on Maths"
Write in as simple English as you can:

(a) (¬p) ∧ q\
I don't like Maths and I'm going to spend at least 6 hours a week on it\
(b) (¬p) ∨ q\
I don't like Maths, or I'm going to spend at least 6 hours a week on it\
(c) ¬(¬p)\
I like maths\
(d) (¬p) ∨ (¬q)\
I don't like maths or I don't like maths\
(e) ¬(p ∨ q)\
I both don't like maths nor am I going to spend at least 6 hours a week on it\
(f) (¬p) ∧ (¬q)
I don't like maths or I'm not ging to spend at least 6 hours a week on it

3. Use bitstring calculations to determine the results for each of the following:

(a) 1100 AND 0111\
1100
0111 AND
0100

(b) 1100 OR 0111\
1100
0111

(c) 1100 XOR 0111\
1100
0111 XOR
1011

(d) 12 OR 11\
1100
1011 OR
1111
== 15

(e) 12 AND 11\
1100
1011 AND
1000
== 8


(f) 12 XOR 11
1100
1011 XOR
0111
== 7

4. Come up with three more logical expressions and express them in English and as logical operators
no



5. Beast
Canvas - Unit Maths Logic https://coderacademy.instructure.com/courses/162/pages/unit-math-logic?module_item_id=7056


6. Beast ++
For each pair of expressions, construct truth tables to see if the two compound propositions are logically equivalent:

(a)
  - (i) p ∨ (q ∧ ¬p)
  - (ii) p ∨ q

(b)
  - (i) ¬p ∨ ¬q
  - (ii) ¬(p ∧ q)