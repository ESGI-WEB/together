package storage

import (
	"fmt"
	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
	"together/utils"
)

var AwsBucketName = aws.String(utils.GetEnv("AWS_BUCKET_NAME", "esgi-together-challenge-test"))
var S3 *s3.S3

func init() {
	fmt.Println("Initializing AWS...")

	awsKey := utils.GetEnv("AWS_ACCESS_KEY_ID", "")
	awsSecretKey := utils.GetEnv("AWS_SECRET_ACCESS_KEY", "")

	if awsKey == "" || awsSecretKey == "" {
		fmt.Println("AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY must be set")
		return
	}

	sess, _ := session.NewSession(&aws.Config{
		Region:   aws.String("fr-par"),
		Endpoint: aws.String("https://s3.fr-par.scw.cloud"),
	})

	newS3 := s3.New(sess)
	S3 = newS3
}
