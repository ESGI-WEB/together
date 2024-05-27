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
	Slug        FeatureSlug `json:"slug" gorm:"primaryKey"`
	Description *string     `json:"description" gorm:"default:null"`
	Enabled     bool        `json:"enabled" gorm:"default:false;not null"`
}
