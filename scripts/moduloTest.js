const someLargeNumber = 8457437
var remaining = 100

var iterations = 6
while (iterations > 0) {
    console.log(someLargeNumber % remaining)
    remaining--;
    iterations--;
}
