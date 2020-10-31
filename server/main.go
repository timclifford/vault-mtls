package main

import (
	"io"
	"log"
	"net/http"
)

func helloHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Hello, world\n")
}

func main() {
	http.HandleFunc("/hello", helloHandler)
	log.Println("Starting server on port 8443")
	log.Fatal(http.ListenAndServeTLS(":8443", "certs/cert.pem", "certs/key.pem", nil))
}
