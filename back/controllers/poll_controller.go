package controllers

import (
	"encoding/json"
	"errors"
	"github.com/go-playground/validator/v10"
	"github.com/jackc/pgx/v5/pgconn"
	"github.com/labstack/echo/v4"
	"net/http"
	"strconv"
	coreErrors "together/errors"
	"together/models"
	"together/services"
	"together/utils"
)

type PollController struct {
	pollService  *services.PollService
	eventService *services.EventService
	groupService *services.GroupService
}

func NewPollController() *PollController {
	return &PollController{
		pollService:  services.NewPollService(),
		eventService: services.NewEventService(),
		groupService: services.NewGroupService(),
	}
}

func (c *PollController) CreatePoll(ctx echo.Context) error {
	var jsonBody models.PollCreateOrEdit
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	user := ctx.Get("user").(models.User)

	// check event access
	if jsonBody.EventID != nil {
		event, err := c.eventService.GetEventByID(*jsonBody.EventID)
		if err != nil {
			return ctx.String(http.StatusNotFound, "Event not found")
		}

		if event.OrganizerID != user.ID {
			return ctx.String(http.StatusForbidden, "You are not the organizer of this event")
		}
	}

	// check group access
	inGroup, err := c.groupService.IsUserInGroup(user.ID, *jsonBody.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	newPoll, err := c.pollService.CreatePoll(user.ID, jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, newPoll)
}

func (c *PollController) GetPollsByEventID(ctx echo.Context) error {
	eventIDQuery, err := strconv.Atoi(ctx.Param("eventId"))
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	eventID := uint(eventIDQuery)

	event, err := c.eventService.GetEventByID(eventID)
	if err != nil || event == nil || event.ID == 0 {
		return ctx.NoContent(http.StatusNotFound)
	}

	// user must be in the group to see the poll
	user := ctx.Get("user").(models.User)
	inGroup, err := c.groupService.IsUserInGroup(user.ID, event.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	pagination := utils.PaginationFromContext(ctx)
	closed := ctx.QueryParam("closed") == "true"
	polls, err := c.pollService.GetPollsForEvent(eventID, pagination, closed)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, polls)
}

func (c *PollController) GetPollsByGroupID(ctx echo.Context) error {
	groupIDQuery, err := strconv.Atoi(ctx.Param("groupId"))
	if err != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}
	groupID := uint(groupIDQuery)

	// user must be in the group to see the poll
	user := ctx.Get("user").(models.User)
	inGroup, err := c.groupService.IsUserInGroup(user.ID, groupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	pagination := utils.PaginationFromContext(ctx)
	closed := ctx.QueryParam("closed") == "true"
	polls, err := c.pollService.GetPollsForGroup(groupID, pagination, closed)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, polls)
}

func (c *PollController) GetPoll(ctx echo.Context) error {
	poll, err := c.basePollPreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// user must be in the group to see the poll
	user := ctx.Get("user").(models.User)
	inGroup, err := c.groupService.IsUserInGroup(user.ID, poll.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	return ctx.JSON(http.StatusOK, poll)
}

func (c *PollController) EditPoll(ctx echo.Context) error {
	poll, err := c.basePollPreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user := ctx.Get("user").(models.User)
	if poll.UserID != user.ID {
		return ctx.String(http.StatusForbidden, "You are not the owner of this poll")
	}

	var jsonBody models.PollCreateOrEdit
	if json.NewDecoder(ctx.Request().Body).Decode(&jsonBody) != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	if jsonBody.Question != nil {
		poll.Question = *jsonBody.Question
	}

	if jsonBody.IsClosed != nil {
		poll.IsClosed = *jsonBody.IsClosed
	}

	if jsonBody.IsMultiple != nil {
		poll.IsMultiple = *jsonBody.IsMultiple
	}

	// used to add new choices, beware, it will not remove the old ones
	// use the delete choice endpoint to remove choices instead
	if jsonBody.Choices != nil {
		choices := *poll.Choices

		for _, choice := range *jsonBody.Choices {
			choiceParsed := choice.ToPollAnswerChoice()
			choiceParsed.PollID = poll.ID
			choices = append(choices, choiceParsed)
		}

		poll.Choices = &choices
	}

	editedPoll, err := c.pollService.EditPoll(*poll)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusOK, editedPoll)
}

func (c *PollController) DeletePoll(ctx echo.Context) error {
	poll, err := c.basePollPreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user := ctx.Get("user").(models.User)
	if poll.UserID != user.ID {
		return ctx.String(http.StatusForbidden, "You are not the owner of this poll")
	}

	err = c.pollService.DeletePoll(poll.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)

}

func (c *PollController) AddChoice(ctx echo.Context) error {
	var jsonBody models.PollAnswerChoiceCreateOrEdit
	if json.NewDecoder(ctx.Request().Body).Decode(&jsonBody) != nil {
		return ctx.NoContent(http.StatusBadRequest)
	}

	poll, err := c.basePollPreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user := ctx.Get("user").(models.User)

	// to add a choice, the user must be in the group, even if user did not create the poll
	inGroup, err := c.groupService.IsUserInGroup(user.ID, poll.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	choice, err := c.pollService.AddPollChoice(poll.ID, jsonBody)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.JSON(http.StatusCreated, choice)
}

func (c *PollController) DeleteChoice(ctx echo.Context) error {
	poll, choice, user, err := c.basePollChoicePreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// to delete a choice, the user must be owner of the poll
	if poll.UserID != user.ID {
		return ctx.String(http.StatusForbidden, "You are not the owner of this poll")
	}

	err = c.pollService.DeletePollChoice(choice.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}

func (c *PollController) SelectChoice(ctx echo.Context) error {
	poll, choice, user, err := c.basePollChoicePreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// to select a choice, the user must be in the group
	inGroup, err := c.groupService.IsUserInGroup(user.ID, poll.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	// check if the choice is already selected by this user
	selectedChoices, err := c.pollService.GetPollChoicesOfUser(poll.ID, user.ID)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	for _, selectedChoice := range selectedChoices {
		if selectedChoice.ID == choice.ID {
			return ctx.String(http.StatusConflict, "You have already selected this choice")
		}
	}

	if !poll.IsMultiple {
		// deselect other choices if the poll is not multiple
		for _, selectedChoice := range selectedChoices {
			err = c.pollService.SelectPollChoice(*user, selectedChoice, false)
			if err != nil {
				return ctx.NoContent(http.StatusInternalServerError)
			}
		}
	}

	err = c.pollService.SelectPollChoice(*user, *choice, true)
	if err != nil {
		var pgErr *pgconn.PgError
		if errors.As(err, &pgErr) && pgErr.Code == "23505" {
			return ctx.String(http.StatusConflict, "You have already selected this choice")
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}

func (c *PollController) DeselectChoice(ctx echo.Context) error {
	poll, choice, user, err := c.basePollChoicePreRequest(ctx)
	if err != nil {
		if errors.Is(err, coreErrors.ErrNotFound) {
			return ctx.NoContent(http.StatusNotFound)
		}
		if errors.Is(err, coreErrors.ErrForbidden) {
			return ctx.NoContent(http.StatusForbidden)
		}
		if errors.Is(err, coreErrors.ErrBadRequest) {
			return ctx.NoContent(http.StatusBadRequest)
		}
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// to unselect a choice, the user must be in the group
	inGroup, err := c.groupService.IsUserInGroup(user.ID, poll.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	err = c.pollService.SelectPollChoice(*user, *choice, false)
	if err != nil {
		return ctx.NoContent(http.StatusInternalServerError)
	}

	return ctx.NoContent(http.StatusNoContent)
}

func (c *PollController) basePollChoicePreRequest(ctx echo.Context) (*models.Poll, *models.PollAnswerChoice, *models.User, error) {
	poll, err := c.basePollPreRequest(ctx)
	if err != nil {
		return nil, nil, nil, err
	}

	choiceIDQuery, err := strconv.Atoi(ctx.Param("choiceId"))
	if err != nil {
		return nil, nil, nil, coreErrors.ErrBadRequest
	}
	choiceID := uint(choiceIDQuery)

	choice, err := c.pollService.GetPollChoiceByID(choiceID)
	if err != nil || choice == nil || choice.ID == 0 || choice.PollID != poll.ID {
		return nil, nil, nil, coreErrors.ErrNotFound
	}

	user := ctx.Get("user").(models.User)

	return poll, choice, &user, nil
}

func (c *PollController) basePollPreRequest(ctx echo.Context) (*models.Poll, error) {
	pollIDQuery, err := strconv.Atoi(ctx.Param("pollId"))
	if err != nil {
		return nil, coreErrors.ErrBadRequest
	}
	pollID := uint(pollIDQuery)

	poll, err := c.pollService.GetPollByID(pollID)
	if err != nil || poll == nil || poll.ID == 0 {
		return nil, coreErrors.ErrNotFound
	}

	if poll.IsClosed {
		return nil, coreErrors.ErrForbidden
	}

	return poll, nil
}
