import 'package:flutter/material.dart';

import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:theatrol/remote_repository/shows.dart';
import 'package:theatrol/services/auth_service.dart';
import 'package:theatrol/services/image_storage.dart';
import 'package:theatrol/theme.dart';
import 'package:universal_io/io.dart';

import '../widget/loading_button.dart';

class ShowPostPage extends StatefulWidget {
  static const id = 'ShowPostPage';

  const ShowPostPage({
    Key? key,
  }) : super(key: key);

  @override
  _ShowPostPageState createState() => _ShowPostPageState();
}

class _ShowPostPageState extends State<ShowPostPage> {
  final GlobalKey<FormState> _fomKey = GlobalKey<FormState>();

  String imageUrl =
      'https://biqvzpvabujhigaadwpf.supabase.co/storage/v1/object/sign/images/0faf0e50206691.58ca21a733c68.jpg?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1cmwiOiJpbWFnZXMvMGZhZjBlNTAyMDY2OTEuNThjYTIxYTczM2M2OC5qcGciLCJpYXQiOjE2NTYyMDU5NjYsImV4cCI6MTk3MTU2NTk2Nn0.PFNYLGn_d2GduGQy7VMyQEc7ZUSZyhTQo-EF-CmjT5g';
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  File? _image;
  XFile? pickedFile;
  final ImagePicker _picker = ImagePicker();

  String _title = '';
  String _description = '';

  //TextEditingController _firstDate = TextEditingController();

  final FocusNode _titleFocus = FocusNode();
  final FocusNode _brandFocus = FocusNode();
  final FocusNode _descriptionFocus = FocusNode();

  //helper variables
  String _message = '';
  bool _showProgressIndicator = false;

  Future<void> getImage() async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {});

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile!.path);
      });
    } else {
      getLostDataImage();
    }
  }

  ///For one image
  Future<void> getLostDataImage() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.read<AuthService>();
    final storageProvider = context.read<ImageStorageService>();
    RemoteShowsService remoteShowsService = RemoteShowsService();
    var horrizontalPadding = MediaQuery.of(context).size.width * 0.25 / 2;

    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
          body: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: horrizontalPadding),
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                physics: const ScrollPhysics(),
                child: Form(
                  key: _fomKey,
                  child: Column(
                    //mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      //mainProductImage(),
                      InkWell(
                        onTap: () {
                          getImage();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          height: 60,
                          width: 100,
                          //color: primaryColor500,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: primaryColor500,
                          ),
                          child: const Text(
                            'Upload Poster Image',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: colorWhite, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      _image != null
                          ? Row(
                              children: [
                                const Icon(
                                  Icons.image,
                                  color: primaryColor500,
                                ),
                                Text(basename(_image!.path)),
                              ],
                            )
                          : const Text(''),
                      //: _buildImagesList(),
                      const SizedBox(height: 40),
                      _showPostInputs(authProvider, context, storageProvider,
                          remoteShowsService),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  void _selectFirstDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 6))
        .then((value) {
      setState(() {
        _startDate = value!;
      });
    });
  }

  void _selectLastDate(BuildContext context) async {
    await showDatePicker(
            context: context,
            initialDate: _startDate,
            firstDate: _startDate,
            lastDate:
                DateTime(_startDate.year, _startDate.month, _startDate.day + 5))
        .then((value) {
      setState(() {
        _endDate = value!;
      });
    });
  }

  Widget _buildStartDateField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'First Date',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _selectFirstDate(context);
            },
            child: TextFormField(
              //controller: _condition,
              enabled: false,
              enableSuggestions: true,
              textInputAction: TextInputAction.next,

              obscureText: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.date_range_rounded,
                    color: primaryColor500,
                  ),
                  hintText: DateFormat('dd/MM/yyyy').format(_startDate),
                  border: InputBorder.none,
                  fillColor: const Color(0xfff3f3f4),
                  filled: true),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEndDateField(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'End Date',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _selectLastDate(context);
            },
            child: TextFormField(
              //controller: _condition,
              enabled: false,
              enableSuggestions: true,
              textInputAction: TextInputAction.next,

              obscureText: false,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.date_range_rounded,
                    color: primaryColor500,
                  ),
                  hintText: DateFormat('dd/MM/yyyy').format(_endDate),
                  border: InputBorder.none,
                  fillColor: const Color(0xfff3f3f4),
                  filled: true),
            ),
          )
        ],
      ),
    );
  }

  Column _showPostInputs(
      AuthService _authServiceProvider,
      BuildContext context,
      ImageStorageService storageServiceProvider,
      RemoteShowsService remoteShowsService) {
    return Column(
      children: [
        _buildTitle(context),
        _buildDescription(),
        _buildStartDateField(context),
        _buildEndDateField(context),
        _buildErrorMessage(),
        const SizedBox(height: 20),
        _showProgressIndicator == false
            ? _submitButton(_authServiceProvider, context,
                storageServiceProvider, remoteShowsService)
            : Row(
                children: const [
                  LoadingButton(),
                ],
              ),
      ],
    );
  }

//methods for building text fields

  Widget _buildTitle(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Title',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            focusNode: _titleFocus,
            enableSuggestions: true,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (v) {
              _titleFocus.unfocus();
              FocusScope.of(context).requestFocus(_brandFocus);
            },
            obscureText: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
                helperText: 'Title',
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please fill in the title';
              }

              return null;
            },
            onSaved: (String? value) {
              value == null ? _title = "" : _title = value;
            },
          )
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Description',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            focusNode: _descriptionFocus,
            maxLines: 10,
            enableSuggestions: true,
            textInputAction: TextInputAction.newline,
            onFieldSubmitted: (v) {
              _descriptionFocus.unfocus();
            },
            obscureText: false,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(
                hintText: 'Description',
                border: InputBorder.none,
                fillColor: Color(0xfff3f3f4),
                filled: true),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description';
              }

              return null;
            },
            onSaved: (String? value) {
              value == null ? _description = "" : _description = value;
            },
          )
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Text(_message,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red));
  }

  Widget _submitButton(
      AuthService authProvider,
      BuildContext context,
      ImageStorageService storageServiceProvider,
      RemoteShowsService remoteShowsService) {
    return InkWell(
      onTap: () {
        FocusScope.of(context).unfocus();
        // if ((_image == null)) {
        //   setState(() {
        //     _message = 'No images picked';
        //   });
        //   return;
        // }

        _fomKey.currentState!.save();

        setState(() => _showProgressIndicator = true);
        //add upload method and progress indicator remover goes here
        remoteShowsService.createShow(
            title: _title,
            description: _description,
            startDate: _startDate,
            endDate: _endDate,
            imageUrl: imageUrl);

        setState(() {
          _showProgressIndicator = false;
        });
        // if (_image != null) {
        //   storageServiceProvider.uploadImage(pickedFile!).then((value) {
        //     remoteShowsService.createShow(
        //         title: _title,
        //         description: _description,
        //         startDate: _startDate,
        //         endDate: _endDate,
        //         imageUrl: value!);

        //     setState(() {
        //       _showProgressIndicator = false;
        //     });
        //   });
        // }
      },
      child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 15),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            color: primaryColor500,
          ),
          child: const Text(
            'Submit',
            style: TextStyle(color: colorWhite),
          )),
    );
  }
}
