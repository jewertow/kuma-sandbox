package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"sync"
)

type server struct {
	mux     *sync.Mutex
	counter int32
}

func main() {
	s := server{&sync.Mutex{}, 0}
	fmt.Println("HTTP server is starting...")
	http.HandleFunc("/echo", s.postHandler(200, nil))
	if err := http.ListenAndServe(":18080", nil); err != nil {
		fmt.Printf("Cannot start server: %s\n", err.Error())
		os.Exit(1)
	}
	os.Exit(0)
}

func (s *server) postHandler(status int, callback func(http.ResponseWriter)) func(w http.ResponseWriter, r *http.Request) {
	return func(w http.ResponseWriter, r *http.Request) {
		counter := s.countAndGet()
		reqBody, err := ioutil.ReadAll(r.Body)
		if err != nil {
			fmt.Println(err.Error())
		}
		fmt.Printf("[%d] Endpoint /%d received request %s\n", counter, status, reqBody)
		fmt.Println("Headers:")
		for name, values := range r.Header {
			for _, value := range values {
				fmt.Println(name, value)
			}
		}
		if callback != nil {
			callback(w)
		}
		w.WriteHeader(status)
	}
}

func (s *server) countAndGet() int32 {
	s.mux.Lock()
	defer s.mux.Unlock()
	s.counter++
	return s.counter
}
