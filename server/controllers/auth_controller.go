package controllers

import (
	"context"
	"io/ioutil"
	"log"
	"net/http"

	jwt "github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/crypto/bcrypt"

	"server/configs"
	"server/models"
	"server/responses"
)

var authCollection *mongo.Collection = configs.GetCollection(configs.DB, "users")
var jwtKey = []byte("Server4224")

// Registers user
func Register() gin.HandlerFunc {
	return func(c *gin.Context) {
		var result models.User
		var user models.User

		//validate the request body
		if err := c.BindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, responses.AuthResponse{
				Status: http.StatusBadRequest, 
				Message: err.Error(), 
				Data: map[string]interface{}{},
			})
			return
		}

		log.Println(user)
		
		err := authCollection.FindOne(context.TODO(),
		bson.D{{
			Key: "email",
			Value: user.Email,
		}}).Decode(&result)
		if err != nil {
			if err.Error() == "mongo: no documents in result" {
				hash, err := bcrypt.GenerateFromPassword([]byte(user.Password), 5)

				if err != nil {
					c.JSON(http.StatusInternalServerError, responses.AuthResponse{
						Status: http.StatusInternalServerError, 
						Message: err.Error(),
						Data: map[string]interface{}{},
					})
					return
				} else {
					user.Password = string(hash)
				}

				_, err = authCollection.InsertOne(context.TODO(), user)
				if err != nil {
					c.JSON(http.StatusInternalServerError, responses.AuthResponse{
						Status: http.StatusInternalServerError, 
						Message: err.Error(), 
						Data: map[string]interface{}{},
					})
					return
				} else {
					c.JSON(http.StatusCreated, responses.AuthResponse{
						Status: http.StatusCreated, 
						Message: "Registration successful",
						Data: map[string]interface{}{
							"name": user.Name,
							"email": user.Email,
						},
					})
					return
				}
			}
		} else {
			c.JSON(http.StatusConflict, responses.AuthResponse{
				Status: http.StatusConflict, 
				Message: "Email already exists, Try loggin in",
				Data: map[string]interface{}{},
			})
			return
		}
	}
}

// Login user
func Login() gin.HandlerFunc {
	return func(c *gin.Context) {
		var result models.User
		var user models.User

		//validate the request body
		if err := c.BindJSON(&user); err != nil {
			c.JSON(http.StatusBadRequest, responses.AuthResponse{
				Status: http.StatusBadRequest, 
				Message: err.Error(), 
				Data: map[string]interface{}{},
			})
			return
		}

		log.Println(user)

		err := authCollection.FindOne(context.TODO(), 
		bson.M{"email": user.Email}).Decode(&result)

		log.Println(result);

		if err != nil {
			c.JSON(http.StatusConflict, responses.AuthResponse{
				Status: http.StatusConflict, 
				Message: "Invalid email", 
				Data: map[string]interface{}{},
			})
			return
		}

		err = bcrypt.CompareHashAndPassword([]byte(result.Password), []byte(user.Password))

		if err != nil {
			c.JSON(http.StatusConflict, responses.AuthResponse{
				Status: http.StatusConflict, 
				Message: "Invalid password", 
				Data: map[string]interface{}{},
			})
			return
		}

		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			"id": result.ID,
			"email":  result.Email,
		})

		tokenString, err := token.SignedString(jwtKey)

		if err != nil {
			c.JSON(http.StatusInternalServerError, responses.AuthResponse{
				Status: http.StatusInternalServerError, 
				Message: "Error while generating token, Try again", 
				Data: map[string]interface{}{},
			})
		} else {
			c.JSON(http.StatusCreated, responses.AuthResponse{
				Status: http.StatusCreated, 
				Message: "success", 
				Data: map[string]interface{}{
					"name": result.Name,
					"email": result.Email,
					"token": tokenString,
				},
			})
		}
			
	}
}

type Claims struct {
	Email    string `json:"email"`
	Id       string `json:"id"`
	jwt.StandardClaims
}

var Email string

// gets token
func GetToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		log.Println(c.Request)
		tknAsByte, err := ioutil.ReadAll(c.Request.Body)
		if err != nil {
			c.JSON(http.StatusBadRequest, responses.AuthResponse{
				Status: http.StatusBadRequest, 
				Message: "error", 
				Data: map[string]interface{}{"data": err.Error()},
			})
			return
		}

		tknStr := string(tknAsByte)

		// Initialize a new instance of `Claims`
		claims := &Claims{}

		// Parse the JWT string and store the result in `claims`.
		// Note that we are passing the key in this method as well. This method will return an error
		// if the token is invalid (if it has expired according to the expiry time we set on sign in),
		// or if the signature does not match
		tkn, err := jwt.ParseWithClaims(tknStr, claims, func(token *jwt.Token) (interface{}, error) {
			return jwtKey, nil
		})
		if err != nil {
			if err == jwt.ErrSignatureInvalid {
				c.JSON(http.StatusUnauthorized, responses.AuthResponse{
					Status: http.StatusUnauthorized, 
					Message: "Unauthorized",
				})
				return
			}
			c.JSON(http.StatusBadRequest, responses.AuthResponse{
				Status: http.StatusBadRequest, 
				Message: "Bad Request",
			})
			return
		}
		if !tkn.Valid {
			c.JSON(http.StatusUnauthorized, responses.AuthResponse{
				Status: http.StatusUnauthorized, 
				Message: "Unauthorized",
			})
			return
		}

		// Finally, return the welcome message to the user, along with their
		// email given in the token
		Email = claims.Email
		c.JSON(http.StatusOK, responses.AuthResponse{
			Status: http.StatusOK, 
			Message: claims.Email,
		})
	}
}