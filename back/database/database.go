package database

import (
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	"strconv"
	"together/models"
	"together/utils"
)

var CurrentDatabase *gorm.DB

type Config struct {
	Host     string
	Port     int
	User     string
	Password string
	Name     string
	SSLMode  string
}

type DB struct {
	DB     *gorm.DB
	Config Config
}

var allModels = []interface{}{
	&models.Address{},
	&models.Attend{},
	&models.Category{},
	&models.Event{},
	&models.Group{},
	&models.Message{},
	&models.Poll{},
	&models.PollAnswerChoice{},
	&models.Reaction{},
	&models.User{},
}

func (db *DB) Connect() error {
	dbConnectionString := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname=%s sslmode=%s",
		db.Config.Host, db.Config.Port, db.Config.User, db.Config.Password, db.Config.Name, db.Config.SSLMode)

	var err error
	db.DB, err = gorm.Open(postgres.Open(dbConnectionString), &gorm.Config{})
	if err != nil {
		return err
	}

	sqlDB, err := db.DB.DB()
	if err != nil {
		return err
	}

	err = sqlDB.Ping()
	if err != nil {
		return err
	}

	return nil
}

func (db *DB) Close() error {
	sqlDB, _ := db.DB.DB()
	return sqlDB.Close()
}

func (db *DB) AutoMigrate() error {
	return db.DB.AutoMigrate(allModels...)
}

func (db *DB) CloseDB() {
	err := db.Close()
	if err != nil {
		fmt.Println(err)
	}
}

func InitDB() (*DB, error) {
	port, err := strconv.Atoi(utils.GetEnv("DB_PORT", "5432"))
	if err != nil {
		return nil, err
	}

	dbConfig := Config{
		Host:     utils.GetEnv("DB_HOST", "localhost"),
		Port:     port,
		User:     utils.GetEnv("DB_USER", "postgres"),
		Password: utils.GetEnv("DB_PASSWORD", "postgres"),
		Name:     utils.GetEnv("DB_NAME", "app"),
		SSLMode:  utils.GetEnv("DB_SSL_MODE", "disable"),
	}

	newDB := DB{Config: dbConfig}
	err = newDB.Connect()
	if err != nil {
		return nil, err
	}

	err = newDB.DB.SetupJoinTable(&models.Event{}, "Participants", &models.Attend{})
	if err != nil {
		return nil, err
	}

	CurrentDatabase = newDB.DB
	return &newDB, nil
}
