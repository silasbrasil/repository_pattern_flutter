import 'package:flutter/material.dart';
import 'package:repositories_management/models/user.dart';
//import 'package:repositories_management/blocs/home_bloc_youtube.dart';
import 'package:repositories_management/blocs/home_bloc_instagram.dart';
import 'package:repositories_management/details_page.dart';

class HomePage extends StatelessWidget {
  final _homeBloc = HomeBlocInstagram();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          print('*** Build Scaffold ***');
          _homeBloc.snackBarCallback = showSnackBar;
          _homeBloc.popUpCallback = myShowDialog;
          _homeBloc.context = context;

          return RefreshIndicator(
            onRefresh: _homeBloc.updateUsers,
            child: Center(
              child: StreamBuilder(
                stream: _homeBloc.users,
                initialData: UserStateLoading(),
                builder:
                    (BuildContext context, AsyncSnapshot<UserState> snapshot) {
                  final state = snapshot.data;
                  if (state is UserStateLoading) return _loadingBuild();
                  if (state is UserStateCached)
                    return _userListCachedBuild(state);
                  if (state is UserStateUpdate) return _userListApiBuild(state);
                  if (state is UserStateEmpty) return _emptyBuild();
                  if (state is UserStateError) return _errorBuild(state);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _userListCachedBuild(UserStateCached state) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: state.data.map(_listTileItemBuild).toList(),
    );
  }

  Widget _userListApiBuild(UserStateUpdate state) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: state.data.map(_listTileItemBuild).toList(),
    );
  }

  Widget _listTileItemBuild(User user) {
    return ListTile(
      title: Text(user.name ?? ''),
      subtitle: Text(user.email ?? ''),
      onTap: () {
        Navigator.push(
          _homeBloc.context,
          MaterialPageRoute(builder: (context) => DetailsPage()),
        );
      },
    );
  }

  Widget _loadingBuild() {
    return ListView(
      children: <Widget>[
        CircularProgressIndicator(),
      ],
    );
  }

  Widget _emptyBuild() {
    return ListView(
      children: <Widget>[
        Text('Nenhum usuário listado'),
      ],
    );
  }

  Widget _errorBuild(UserStateError state) {
    return ListView(
      children: <Widget>[
        Container(
          color: Colors.redAccent,
          child: Text(state.message),
        ),
      ],
    );
  }

  void showSnackBar(String message, BuildContext context) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<void> myShowDialog(String message, BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Verifique sua conexão com a internet!'),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
