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

type Filter struct {
	Value    interface{} `json:"value" validate:"required"`
	Operator string      `json:"operator" validate:"required,oneof= != > < >= <= ="`
}

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
	&models.Event{},
	&models.Group{},
	&models.Message{},
	&models.Poll{},
	&models.PollAnswerChoice{},
	&models.Reaction{},
	&models.User{},
	&models.FeatureFlipping{},
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
	err := db.DB.AutoMigrate(allModels...)
	if err != nil {
		return err
	}

	return db.FillFeatureFlipping()
}

func (db *DB) FillFeatureFlipping() error {
	// First get already inserted features
	var features []models.FeatureFlipping
	err := db.DB.Find(&features).Error
	if err != nil {
		return err
	}

	// delete extra features not used anymore
	err = db.DB.Where("slug NOT IN ?", models.AllFeatureSlugs).Delete(&models.FeatureFlipping{}).Error
	if err != nil {
		return err
	}

	// Insert missing features not already inserted
	for _, feature := range models.AllFeatureSlugs {
		var found bool
		for _, f := range features {
			if f.Slug == feature {
				found = true
				break
			}
		}
		if !found {
			newFeature := models.FeatureFlipping{
				Slug:    feature,
				Enabled: true,
			}
			err = db.DB.Create(&newFeature).Error
			if err != nil {
				return err
			}
		}
	}

	return nil
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
