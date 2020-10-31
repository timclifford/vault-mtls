package main

import (
	"crypto/tls"
	"crypto/x509"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
)

func createCertPool() *x509.CertPool {
	rootCert, err := ioutil.ReadFile("certs/root.pem")
	if err != nil {
		log.Fatal(err)
	}
	certPool := x509.NewCertPool()
	certPool.AppendCertsFromPEM(rootCert)

	return certPool
}

func constructURL() string {
	domain, domainProvided := os.LookupEnv("MTLS_SERVER_DOMAIN")
	if !domainProvided {
		log.Fatal("Please set the MTLS_SERVER_DOMAIN environment variable")
	}

	return fmt.Sprintf("https://%s:8443/hello", domain)
}

func callServer(url string, client *http.Client) []byte {
	r, err := client.Get(url)
	if err != nil {
		log.Fatal(err)
	}

	defer r.Body.Close()
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		log.Fatal(err)
	}

	return body
}

func main() {
	url := constructURL()
	certPool := createCertPool()

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs: certPool,
			},
		},
	}

	for {
		body := callServer(url, client)
		fmt.Printf("%s\n", body)
		time.Sleep(1 * time.Second)
	}
}
