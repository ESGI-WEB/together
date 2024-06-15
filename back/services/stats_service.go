package services

import (
	"together/database"
	"together/models"
)

type MonthlyChartData struct {
	Month int `json:"month"`
	Year  int `json:"year"`
	Count int `json:"count"`
}

type RatioChartData struct {
	Name  string `json:"name"`
	Count int    `json:"count"`
}

type StatsService struct{}

func NewStatsService() *StatsService {
	return &StatsService{}
}

func (s *StatsService) GetMonthlyLastYearRegistrationsCount() ([]MonthlyChartData, error) {
	var chartData []MonthlyChartData

	err := database.CurrentDatabase.Model(models.User{}).
		Select("EXTRACT(MONTH FROM created_at) AS month, EXTRACT(YEAR FROM created_at) AS year, COUNT(*) AS count").
		Where("created_at >= DATE_TRUNC('month', NOW()) - INTERVAL '1 year'").
		Group("year, month").
		Order("year ASC, month ASC").
		Scan(&chartData).Error

	if err != nil {
		return nil, err
	}

	return chartData, nil
}

func (s *StatsService) GetMonthlyMessagesCount() ([]MonthlyChartData, error) {
	var chartData []MonthlyChartData

	err := database.CurrentDatabase.Model(models.Message{}).
		Select("EXTRACT(MONTH FROM created_at) AS month, EXTRACT(YEAR FROM created_at) AS year, COUNT(*) AS count").
		Where("created_at >= DATE_TRUNC('month', NOW()) - INTERVAL '1 year'").
		Group("year, month").
		Order("year ASC, month ASC").
		Scan(&chartData).Error

	if err != nil {
		return nil, err
	}

	return chartData, nil
}

func (s *StatsService) GetEventTypesCount() ([]RatioChartData, error) {
	var chartData []RatioChartData

	err := database.CurrentDatabase.Model(models.EventType{}).
		Joins("LEFT JOIN events ON event_types.id = events.type_id").
		Select("event_types.name, count(events.id) as count").
		Group("event_types.name").
		Order("count DESC").
		Scan(&chartData).Error

	if err != nil {
		return nil, err
	}

	return chartData, nil
}
