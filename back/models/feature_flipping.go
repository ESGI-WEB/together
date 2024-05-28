package models

type FeatureSlug string

const (
	FSlugLogin    FeatureSlug = "login"
	FSlugRegister FeatureSlug = "register"
)

var AllFeatureSlugs = []FeatureSlug{
	FSlugLogin,
	FSlugRegister,
}

type FeatureFlipping struct {
	Slug    FeatureSlug `json:"slug" gorm:"primaryKey"`
	Enabled bool        `json:"enabled" gorm:"default:false;not null"`
}

type EditFeatureFlipping struct {
	Enabled *bool `json:"enabled" validate:"required"`
}
