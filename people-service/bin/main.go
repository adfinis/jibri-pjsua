package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
)

type Person struct {
	Id   string `json:"id"`
	Name string `json:"name"`
	Type string `json:"type"`
}

var people []Person

func init() {
	fileContents, _ := ioutil.ReadFile("people.json")
	json.Unmarshal(fileContents, &people)
}
func handler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	data, _ := json.Marshal(people)
	w.Write(data)
}

func serverStarted() {
	log.Println("Server started on port 9080")
}

func main() {
	http.HandleFunc("/", handler)
	go serverStarted()

	log.Fatal(http.ListenAndServe(":9080", nil))
}
