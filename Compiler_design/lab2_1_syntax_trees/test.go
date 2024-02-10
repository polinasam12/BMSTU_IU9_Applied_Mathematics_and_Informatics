package main

import "fmt"

func square(x int) int {
	var y int
	y = x * x
	return y
}

func main() {
	var s int
	s = square(5)
	fmt.Println(s)
}
