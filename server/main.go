package main

import (
	"server/configs"
	"server/routers"

	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	//run database
	configs.ConnectDB()

	//routes
	routers.AuthRoute(router)

	router.Run("localhost:8080")
}