import 'package:flutter/material.dart';
import 'package:repositories_management/models/user.dart';
//import 'package:repositories_management/blocs/home_bloc_youtube.dart';
import 'package:repositories_management/blocs/home_bloc_instagram.dart';

class HomePage extends StatelessWidget {
  final _homeBloc = HomeBlocInstagram();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Repositories'),
      ),
      body: RefreshIndicator(
        onRefresh: _homeBloc.updateUsers,
        child: Center(
          child: StreamBuilder(
            stream: _homeBloc.users,
            initialData: UserStateLoading(),
            builder: (BuildContext context, AsyncSnapshot<UserState> snapshot) {
              final state = snapshot.data;
              _homeBloc.currentContext = context;

              if (state is UserStateLoading) return _loadingBuild();
              if (state is UserStateCached) return _userListCachedBuild(state);
              if (state is UserStateUpdate) return _userListApiBuild(state);
              if (state is UserStateEmpty) return _emptyBuild();
              if (state is UserStateError) return _errorBuild(state);
            },
          ),
        ),
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
}
