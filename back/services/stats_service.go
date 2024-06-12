package services

import (
	"together/database"
)

type MonthlyChartData struct {
	Month int `json:"month"`
	Year  int `json:"year"`
	Count int `json:"count"`
}

type StatsService struct{}

func NewStatsService() *StatsService {
	return &StatsService{}
}

func (s *StatsService) GetLastYearRegistrationsCount() ([]MonthlyChartData, error) {
	var chartData []MonthlyChartData

	// GORM query to get the registration counts grouped by month and year
	err := database.CurrentDatabase.Table("users").
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
