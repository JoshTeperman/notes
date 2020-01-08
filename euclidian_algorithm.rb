# 1. EUCLIDIAN ALGORITHM / Greatest Common Denominator

# The greatest common divisor (GCD) of two integers is the largest integer
# that evenly divides each of the numbers. Write a method gcd that 
# returns the greatest common divisor of two integers.

# https://www.khanacademy.org/computing/computer-science/cryptography/modarithmetic/a/the-euclidean-algorithm

def gcd(integer1, integer2)
  return "GCD is #{integer1}" if integer2 == 0    
  remainder = integer1 % integer2
  gcd(integer2, remainder)
end
