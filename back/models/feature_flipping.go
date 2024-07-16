package models

type FeatureSlug string

const (
	FSlugRegister    FeatureSlug = "register"
	FSlugCreateGroup FeatureSlug = "create_group"
	FSlugCreateEvent FeatureSlug = "create_event"
	FSlugChat        FeatureSlug = "chat"
)

var AllFeatureSlugs = []FeatureSlug{
	FSlugRegister,
	FSlugCreateGroup,
	FSlugCreateEvent,
	FSlugChat,
}

type FeatureFlipping struct {
	Slug    FeatureSlug `json:"slug" gorm:"primaryKey"`
	Enabled bool        `json:"enabled" gorm:"default:false;not null"`
}

type EditFeatureFlipping struct {
	Enabled *bool `json:"enabled" validate:"required"`
}
