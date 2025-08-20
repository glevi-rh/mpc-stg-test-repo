package main

import "runtime"

func main() {
	println("OS:", runtime.GOOS)
	println("ARCH:", runtime.GOARCH)
	println("Done")
	println("Hello, World!")
}
