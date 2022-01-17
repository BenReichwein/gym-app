package routers 

import (
	"server/controllers"

	"github.com/gin-gonic/gin"
)

func AuthRoute(router *gin.Engine) {
	router.POST("/auth/gettoken", controllers.GetToken())
	router.POST("/auth/login", controllers.Login())
	router.POST("/auth/register", controllers.Register())
}