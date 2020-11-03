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

func main() {
	serverURL := constructURLFromEnv("MTLS_SERVER", "/hello")
	certPool := createCertPool("./certs/root.pem")

	client := &http.Client{
		Transport: &http.Transport{
			TLSClientConfig: &tls.Config{
				RootCAs: certPool,
			},
		},
	}

	for {
		body := callServer(serverURL, client)
		fmt.Printf("%s\n", body)
		time.Sleep(1 * time.Second)
	}
}

func constructURLFromEnv(key, endpoint string) string {
	domain, domainProvided := os.LookupEnv(key)
	if !domainProvided {
		log.Fatal("Please set the", key, "environment variable")
	}

	return fmt.Sprintf("%s%s", domain, endpoint)
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
