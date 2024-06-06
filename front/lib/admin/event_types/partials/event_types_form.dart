import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front/admin/event_types/blocs/event_types_bloc.dart';
import 'package:front/core/models/event_type.dart';
import 'package:front/core/partials/error_occurred.dart';
import 'package:go_router/go_router.dart';

class EventTypesForm extends StatefulWidget {
  final void Function()? onFormCancel;
  final void Function()? onFormCreated;

  const EventTypesForm({
    super.key,
    this.onFormCancel,
    this.onFormCreated,
  });

  @override
  State<EventTypesForm> createState() => _EventTypesScreenState();
}

class _EventTypesScreenState extends State<EventTypesForm> {
  final _formKey = GlobalKey<FormState>();
  Image? _selectedImage;
  bool _isHovering = false;
  bool _isImageMissing = false;
  EventTypeCreateOrEdit _eventTypeCreating = EventTypeCreateOrEdit();

  void _resetForm() {
    setState(() {
      _formKey.currentState?.reset();
      _selectedImage = null;
      _isHovering = false;
      _isImageMissing = false;
      _eventTypeCreating = EventTypeCreateOrEdit();
      widget.onFormCreated?.call();
    });
  }

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
    );

    if (result != null) {
      setState(() {
        final path = result.files.single.xFile.path;
        _selectedImage = Image.network(path);
        _eventTypeCreating =
            _eventTypeCreating.copyWith(image: result.files.single);
        _isImageMissing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EventTypesBloc, EventTypesState>(
      listener: (context, state) {
        if (state.status == EventTypesStatus.addOrEditTypeSuccess) {
          _resetForm();
        }
      },
      child: BlocBuilder<EventTypesBloc, EventTypesState>(
        builder: (context, state) {
          return Container(
            width: 400,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Wrap(
                runSpacing: 20,
                children: <Widget>[
                  Text(
                    _eventTypeCreating.id == null
                        ? 'Ajouter un type d\'évènement'
                        : 'Modifier un type d\'évènement',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  TextFormField(
                    enabled:
                        state.status != EventTypesStatus.addOrEditTypeLoading,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _eventTypeCreating =
                          _eventTypeCreating.copyWith(name: value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      if (value.length < 3) {
                        return 'Le nom doit contenir au moins 3 caractères';
                      }
                      if (value.length > 30) {
                        return 'Le nom doit contenir au maximum 30 caractères';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    enabled:
                        state.status != EventTypesStatus.addOrEditTypeLoading,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _eventTypeCreating =
                          _eventTypeCreating.copyWith(description: value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                  ),
                  if (_selectedImage == null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.image),
                      label: const Text('Sélectionner une image'),
                      onPressed:
                          state.status != EventTypesStatus.addOrEditTypeLoading
                              ? _pickImage
                              : null,
                    ),
                  if (_selectedImage != null)
                    MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _isHovering = true;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _isHovering = false;
                        });
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: _selectedImage!.image,
                            width: 100,
                            height: 100,
                          ),
                          if (_isHovering)
                            Positioned(
                              child: IconButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                icon: Icon(
                                  Icons.edit,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                                onPressed: state.status !=
                                        EventTypesStatus.addOrEditTypeLoading
                                    ? _pickImage
                                    : null,
                              ),
                            ),
                        ],
                      ),
                    ),
                  if (_isImageMissing)
                    Text(
                      'Veuillez sélectionner une image',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (state.status == EventTypesStatus.addOrEditTypeError)
                    Text(
                      state.errorMessage ??
                          "Une erreur est survenue lors de la sauvegarde du type d'évènement",
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: widget.onFormCancel,
                        child: const Text('Annuler'),
                      ),
                      const SizedBox(width: 20),
                      if (state.status == EventTypesStatus.addOrEditTypeLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isImageMissing = false;
                            });

                            if (_formKey.currentState!.validate() &&
                                _eventTypeCreating.image != null) {
                              BlocProvider.of<EventTypesBloc>(context).add(
                                EventTypeEdited(_eventTypeCreating),
                              );
                            } else {
                              setState(() {
                                _isImageMissing =
                                    _eventTypeCreating.image == null;
                              });
                            }
                          },
                          child: const Text('Ajouter'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
