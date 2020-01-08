def find_remainder(remainder, divisor)
  return remainder % divisor
end

def find_quotient(remainder, divisor)
  return remainder / divisor
end

def decimal_to_base_converter(decimal, base)
  answer = []
  remainder = decimal
  divisor = base
  quotient = remainder

  while quotient > base - 1
    remainder = find_remainder(remainder, divisor)
    quotient = find_quotient(remainder, divisor)
    p remainder, quotient
    answer.push(remainder)
  end
  answer.push(quotient)
  answer.map(&:to_s).join('').to_i
end

p decimal_to_base_converter(15, 8)


# 8**1*1 + 8**0*7 == 17
# 15 / 8 = 1, with remainder = (15 % 8) = 7
#  7 / 8 = 0, with remainder = 7 % 8 = 7
# therefore if quotient = 0, push remainder

# 15 / 8 == 1
# + (remainder of 15 % 8) / 8 == 0, therefore return 15 % 8 == 7

# contiue until quotient < base
# quotient = 150remainder / 8base = 18 with remainder 6
# push remainder 6
# quotient = 18quotient / 8base = 2 with remainder 2,
# push remainder 2
# quotient < base, therefore break
# push quotient 2


