package main

import (
	"crypto/tls"
	"crypto/x509"
	"io"
	"io/ioutil"
	"log"
	"net/http"
)

func main() {
	certPool := createCertPool("./certs/root.pem")
	tlsConfig := &tls.Config{
		ClientCAs:  certPool,
		ClientAuth: tls.RequireAndVerifyClientCert,
	}

	server := &http.Server{
		Addr:      ":8443",
		TLSConfig: tlsConfig,
	}

	http.HandleFunc("/hello", helloHandler)
	log.Println("Starting server on port 8443")
	log.Fatal(server.ListenAndServeTLS("certs/cert.pem", "certs/key.pem"))
}

func createCertPool(certPath string) *x509.CertPool {
	rootCert, err := ioutil.ReadFile(certPath)
	if err != nil {
		log.Fatal(err)
	}
	certPool := x509.NewCertPool()
	certPool.AppendCertsFromPEM(rootCert)

	return certPool
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	io.WriteString(w, "Hello, world\n")
}
