// Palindromes

function palindrome(str) {
  const letters = str.match(/[a-z0-9]/ig).join("").toLowerCase();
  let reversedStr = ''
  for (var letter in letters) {
    reversedStr = letters[letter] + reversedStr
  }
  return reversedStr == letters
} 
palindrome("eye");


// Reverse Words in a string
function reverseWords(str) {
  var answer = str.split(" ").map(function(word) {
    return word.split("").reverse().join("");
  });
  return answer.join(" ")
}

// To Reverse a whole string
function reverseString(str) {
  var answer = "";
  var len = str.length;
  
  for (i = 0; i < len; i ++) {
    answer = str[i].concat(answer);
  }
  return answer
}


// forEach function
function forEach(items, callback) {
  for (let index = 0; index < items.length; index++) {
    callback(items[index]);
  }
}