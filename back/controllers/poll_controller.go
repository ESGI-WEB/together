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
	pollService      *services.PollService
	eventService     *services.EventService
	groupService     *services.GroupService
	websocketService *services.WebSocketService
}

func NewPollController() *PollController {
	return &PollController{
		pollService:      services.NewPollService(),
		eventService:     services.NewEventService(),
		groupService:     services.NewGroupService(),
		websocketService: services.NewWebSocketService(),
	}
}

func (c *PollController) CreatePoll(ctx echo.Context) error {
	var jsonBody models.PollCreateOrEdit
	err := json.NewDecoder(ctx.Request().Body).Decode(&jsonBody)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusBadRequest)
	}

	user := ctx.Get("user").(models.User)

	// check event exists
	if jsonBody.EventID != nil {
		event, err := c.eventService.GetEventByID(*jsonBody.EventID)
		if err != nil || event == nil || event.ID == 0 {
			ctx.Logger().Error(err)
			return ctx.String(http.StatusNotFound, "Event not found")
		}
		jsonBody.GroupID = &event.GroupID
	}

	// check group access
	inGroup, err := c.groupService.IsUserInGroup(user.ID, *jsonBody.GroupID)
	if err != nil || !inGroup {
		ctx.Logger().Error(err)
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	newPoll, err := c.pollService.CreatePoll(user.ID, jsonBody)
	if err != nil {
		ctx.Logger().Error(err)
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(newPoll.ID)
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user := ctx.Get("user").(models.User)
	if !c.pollService.HasEditPermission(user.ID, poll.ID) {
		return ctx.String(http.StatusForbidden, "You do not have permission to edit this poll")
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

	editedChoices := make([]models.PollAnswerChoice, 0)
	if jsonBody.Choices != nil {
		// it's a PUT, so all choices must be sent
		// if choice has an id, it is an existing choice that is being edited
		// otherwise, it is a new choice to create
		// if the choice is not in the json body, it is deleted
		for _, choice := range *jsonBody.Choices {
			choiceParsed := choice.ToPollAnswerChoice()
			choiceParsed.PollID = poll.ID

			if choice.ID != nil {
				// TODO check if the choice belongs to the poll
				choiceTarget, err := c.pollService.GetPollChoiceByID(*choice.ID)
				if err != nil {
					ctx.Logger().Error(err)
					return ctx.NoContent(http.StatusInternalServerError)
				}
				if choiceTarget.PollID != poll.ID {
					return ctx.String(http.StatusForbidden, "Choice does not belong to the poll")
				}
				choiceParsed.ID = *choice.ID
			}

			editedChoices = append(editedChoices, choiceParsed)
		}
	}

	if len(editedChoices) > 0 {
		err = c.pollService.EditPollChoices(*poll, editedChoices)
		if err != nil {
			ctx.Logger().Error(err)
			return ctx.NoContent(http.StatusInternalServerError)
		}
	}

	editedPoll, err := c.pollService.EditPoll(*poll)
	if err != nil {
		var validationErrs validator.ValidationErrors
		if errors.As(err, &validationErrs) {
			validationErrors := utils.GetValidationErrors(validationErrs, jsonBody)
			return ctx.JSON(http.StatusUnprocessableEntity, validationErrors)
		}
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(editedPoll.ID)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	user := ctx.Get("user").(models.User)
	if !c.pollService.HasEditPermission(user.ID, poll.ID) {
		return ctx.String(http.StatusForbidden, "You do not have permission to edit this poll")
	}

	err = c.pollService.DeletePoll(poll.ID)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollDeleted(poll.ID, poll.GroupID)
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(poll.ID)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// to delete a choice, the user must be owner of the poll
	if !c.pollService.HasEditPermission(user.ID, poll.ID) {
		return ctx.String(http.StatusForbidden, "You do not have permission to edit this poll")
	}

	err = c.pollService.DeletePollChoice(choice.ID)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(poll.ID)
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
		ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
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
				ctx.Logger().Error(err)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(poll.ID)
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
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	// to unselect a choice, the user must be in the group
	inGroup, err := c.groupService.IsUserInGroup(user.ID, poll.GroupID)
	if err != nil || !inGroup {
		return ctx.String(http.StatusForbidden, "You do not have access to this group")
	}

	err = c.pollService.SelectPollChoice(*user, *choice, false)
	if err != nil {
		ctx.Logger().Error(err)
		return ctx.NoContent(http.StatusInternalServerError)
	}

	c.notifyUsersOfPollChange(poll.ID)

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

func (c *PollController) notifyUsersOfPollChange(pollID uint) {
	poll, err := c.pollService.GetPollByID(pollID)
	if err != nil {
		return
	}

	pollWsMessage := services.ServerBoundGroupBroadcast{
		TypeMessage: services.TypeMessage{
			Type: services.ServerBoundPollUpdatedMessageType,
		},
		Content: poll,
	}

	bytes, err := json.Marshal(pollWsMessage)
	if err != nil {
		return
	}

	err = c.websocketService.BroadcastToGroup(bytes, poll.GroupID)
	if err != nil {
		return
	}

	return
}

func (c *PollController) notifyUsersOfPollDeleted(pollID uint, groupID uint) {
	pollWsMessage := services.ServerBoundGroupBroadcast{
		TypeMessage: services.TypeMessage{
			Type: services.ServerBoundPollDeletedMessageType,
		},
		Content: pollID,
	}

	bytes, err := json.Marshal(pollWsMessage)
	if err != nil {
		return
	}

	err = c.websocketService.BroadcastToGroup(bytes, groupID)
	if err != nil {
		return
	}

	return
}
