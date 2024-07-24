package main

import (
	"log"
	"math/rand"
	"net/http"
	"time"

	"github.com/gorilla/websocket"
)

var upgrader = websocket.Upgrader{
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
	CheckOrigin: func(r *http.Request) bool {
		return true
	},
}

func handler(w http.ResponseWriter, r *http.Request) {
	conn, err := upgrader.Upgrade(w, r, nil)

	if err != nil {
		log.Println("Failed to upgrade to WebSocket:", err)
		return
	}

	defer conn.Close()

	for {
		data := map[string]float64{
			"internal_temperature": float64(rand.Intn(40)+350) / 10,
			"external_temperature": float64(rand.Intn(20)+280) / 10,
			"voltage":              float64(rand.Intn(50)+750) / 10,
			"lat":                  float64(rand.Intn(180000)-90000) / 1000,
			"lon":                  float64(rand.Intn(180000)) / 1000,
		}

		err := conn.WriteJSON(data)
		if err != nil {
			log.Println("Error writing JSON to WebSocket:", err)
			return
		}

		time.Sleep(1 * time.Second)
	}
}

func main() {
	http.HandleFunc("/", handler)

	log.Fatal(http.ListenAndServe(":7041", nil))
}
